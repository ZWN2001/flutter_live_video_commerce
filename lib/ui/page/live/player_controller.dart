import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:get/get.dart';
import 'package:ns_danmaku/danmaku_controller.dart';
import 'package:ns_danmaku/models/danmaku_item.dart';
import 'package:ns_danmaku/models/danmaku_option.dart';

mixin PlayerMixin {
  GlobalKey<VideoState> globalPlayerKey = GlobalKey<VideoState>();

  /// 播放器实例
  late final player = Player(
    configuration: const PlayerConfiguration(
      title: "Live Player",
    ),
  );

  /// 视频控制器
  late final videoController = VideoController(
      player,
      configuration: const VideoControllerConfiguration(
        vo: 'mediacodec_embed',
        hwdec: 'mediacodec',
      )
  );
}

mixin PlayerStateMixin on PlayerMixin {
  /// 是否显示弹幕
  RxBool showDanmakuState = false.obs;

  /// 是否显示控制器
  RxBool showControlsState = false.obs;

  /// 自动隐藏控制器计时器
  Timer? hideControlsTimer;

  /// 是否处于全屏状态
  RxBool fullScreenState = false.obs;

  /// 是否为竖屏直播间
  var isVertical = false.obs;


  /// 隐藏控制器
  void hideControls() {
    showControlsState.value = false;
    hideControlsTimer?.cancel();
  }

  /// 显示控制器
  void showControls() {
    showControlsState.value = true;
    resetHideControlsTimer();
  }

  /// 开始隐藏控制器计时
  /// - 当点击控制器上时功能时需要重新计时
  void resetHideControlsTimer() {
    hideControlsTimer?.cancel();

    hideControlsTimer = Timer(
      const Duration(
        seconds: 5,
      ),
      hideControls,
    );
  }

  /// 进入全屏
  void enterFullScreen() {
    fullScreenState.value = true;
    //全屏
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    if (!isVertical.value) {
      //横屏
      setLandscapeOrientation();
    }
    //danmakuController?.clear();
  }

  /// 退出全屏
  void exitFull() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: SystemUiOverlay.values);
    setPortraitOrientation();
    fullScreenState.value = false;
    //danmakuController?.clear();
  }

  /// 设置横屏
  Future setLandscapeOrientation() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// 设置竖屏
  Future setPortraitOrientation() async {
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }
}

mixin PlayerGestureControlMixin
on PlayerStateMixin, PlayerMixin{

  /// 单击显示/隐藏控制器
  void onTap() {
    if (showControlsState.value) {
      hideControls();
    } else {
      showControls();
    }
  }

  /// 双击全屏/退出全屏
  void onDoubleTap(TapDownDetails details) {
    if (fullScreenState.value) {
      exitFull();
    } else {
      enterFullScreen();
    }
  }
}

mixin PlayerDanmakuMixin on PlayerStateMixin {
  /// 弹幕控制器
  DanmakuController? danmakuController;

  void initDanmakuController(DanmakuController e) {
    danmakuController = e;
  }

  void updateDanmuOption(DanmakuOption? option) {
    if (danmakuController == null || option == null) return;
    danmakuController!.updateOption(option);
  }

  void disposeDanmakuController() {
    danmakuController?.clear();
  }

  void addDanmaku(List<DanmakuItem> items) {
    if (!showDanmakuState.value) {
      return;
    }
    danmakuController?.addItems(items);
  }
}

class PlayerController extends GetxController
    with
        PlayerMixin,
        PlayerStateMixin,
        PlayerDanmakuMixin,
    // PlayerSystemMixin,
        PlayerGestureControlMixin {
  @override
  void onInit() {
    // initSystem();
    initStream();
    super.onInit();
  }

  StreamSubscription<String>? _errorSubscription;
  StreamSubscription? _completedSubscription;
  StreamSubscription? _widthSubscription;
  StreamSubscription? _heightSubscription;
  StreamSubscription? _logSubscription;

  void initStream() {
    _errorSubscription = player.stream.error.listen((event) {
      mediaError(event);
    });

    _completedSubscription = player.stream.completed.listen((event) {
      if (event) {
        mediaEnd();
      }
    });

    _widthSubscription = player.stream.width.listen((event) {

      // isVertical.value =
      //     (player.state.height ?? 9) > (player.state.width ?? 16);
    });
    _heightSubscription = player.stream.height.listen((event) {
      // isVertical.value =
      //     (player.state.height ?? 9) > (player.state.width ?? 16);
    });
  }

  void disposeStream() {
    _errorSubscription?.cancel();
    _completedSubscription?.cancel();
    _widthSubscription?.cancel();
    _heightSubscription?.cancel();
    _logSubscription?.cancel();
    // _pipSubscription?.cancel();
  }

  void mediaEnd() {}

  void mediaError(String error) {}

  @override
  void onClose() async {
    disposeStream();
    disposeDanmakuController();
    // await resetSystem();
    await player.dispose();
    super.onClose();
  }
}