import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:live_video_commerce/ui/widget/live_room_chat_area.dart';
import 'package:media_kit_video/media_kit_video.dart';

import 'package:ns_danmaku/danmaku_view.dart';
import 'package:ns_danmaku/models/danmaku_item.dart';
import 'package:ns_danmaku/models/danmaku_option.dart';

import '../../widget/show_commodities_list_sheet.dart';
import 'live_controller.dart';

class LiveRoomPage extends GetView<LiveRoomController>  {
  const LiveRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LiveRoomController());
    return Obx(
          () {
        if (controller.fullScreenState.value) {
          return PopScope(
            canPop: false,
            onPopInvoked: (e) {
              controller.exitFull();
            },
            child: Scaffold(
              body: buildMediaPlayer(),
            ),
          );
        } else {
          return buildPageUI(context);
        }
      },
    );
  }

  Widget buildMediaPlayer() {
    var boxFit = BoxFit.contain;
    double? aspectRatio = 16 / 9;
    return Stack(
      children: [
        Video(
          key: controller.globalPlayerKey,
          controller: controller.videoController,
          pauseUponEnteringBackgroundMode: false,
          resumeUponEnteringForegroundMode: false,
          controls: (state) {
            return playerControls(state, controller);
          },
          aspectRatio: aspectRatio,
          fit: boxFit,
        ),
        // Obx(
        //       () =>
              Visibility(
                visible: controller.liveRoom.status == 1,
                child: const Center(
                  child: Text(
                    "未开播",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
        // ),
      ],
    );
  }

  Widget buildPageUI(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(controller.liveRoom.roomName)),
        floatingActionButton: _commodityButtons(context),
        body: Column(children: <Widget>[
          AspectRatio(
            aspectRatio: 16 / 9,
            child: buildMediaPlayer(),
          ),
          // SizedBox(
          //   width: Get.width,
          //   child: Stack(
          //     children: [
          //       _videoArea(),
          //       Positioned(
          //           top: 14,
          //           width: Get.width,
          //           height: Get.width * Get.size.aspectRatio + 60,
          //           child: DanmakuView(
          //             key: UniqueKey(),
          //             createdController: (controller) {
          //               danmakuController = controller;
          //             },
          //             option: DanmakuOption(
          //               fontSize: 16,
          //             ),
          //           )
          //       ),
          //       Positioned(
          //         top: 0,
          //         width: Get.width,
          //         height: Get.width * Get.size.aspectRatio + 50,
          //         child: GestureDetector(
          //           onTap: () {
          //             setState(() {
          //               showDanmakuState =
          //               !showDanmakuState;
          //             });
          //           },
          //           child: showDanmakuState
          //               ? _videoPlayerControlArea()
          //               : Container(
          //             color: Colors.transparent,
          //           ),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          const Expanded(
              child: Stack(
                children: [
                  ChatArea(),
                  //TODO
                ],
              )
          ),
          const SizedBox(height: 8,),
          _bottomArea(),
          const SizedBox(height: 8,)
        ]));
  }

  Widget _bottomArea() {
    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextField(
            controller: controller.barrageEditingController,
            // cursorWidth: 1.5,
            style: const TextStyle(
              color: Color(0xff333333),
              fontSize: 14.0,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
              fillColor: Colors.grey[200],
              filled: true,
              border: const OutlineInputBorder(borderSide: BorderSide.none),
              hintText: '吐个槽呗~',
            ),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.send,
            color: Colors.cyan,
          ),
          onPressed: () {
            if (controller.barrageEditingController.text.isEmpty) return;
            controller.addDanmaku([
              DanmakuItem(
                controller.barrageEditingController.text,
            ),]);
            controller.barrageEditingController.clear();
          },
        )
      ],
    );
  }

  Widget _commodityButtons(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blue,
          child: IconButton(
              color: Colors.white,
              icon: const Icon(Icons.shopping_bag_outlined),
              onPressed: () {
                ShowCommoditiesListSheet.showCommoditiesListSheet(context, controller.commodities);
              }
          ),
        ),
        const SizedBox(
          height: 48,
        ),
      ],
    );
  }

  Widget playerControls(
      VideoState videoState,
      LiveRoomController controller,
      ) {
    return Obx(() {
      if (controller.fullScreenState.value) {
        return buildFullControls(
          videoState,
          controller,
        );
      }
      return buildControls(
        videoState.context.orientation == Orientation.portrait,
        videoState,
        controller,
      );
    });
  }

  Widget buildFullControls(
      VideoState videoState,
      LiveRoomController controller,
      ) {
    var padding = MediaQuery.of(videoState.context).padding;

    return Stack(
      children: [
        Container(),
        buildDanmuView(videoState, controller),

        Center(
          child: // 中间
          StreamBuilder(
            stream: videoState.widget.controller.player.stream.buffering,
            initialData: videoState.widget.controller.player.state.buffering,
            builder: (_, s) => Visibility(
              visible: s.data ?? false,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: GestureDetector(
            onTap: controller.onTap,
            onDoubleTapDown: controller.onDoubleTap,
            onLongPress: () {
              // showFollowUser(controller);
            },
            // onVerticalDragStart: controller.onVerticalDragStart,
            // onVerticalDragUpdate: controller.onVerticalDragUpdate,
            // onVerticalDragEnd: controller.onVerticalDragEnd,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
            ),
          ),
        ),

        // 顶部
        Obx(
              () => AnimatedPositioned(
            left: 0,
            right: 0,
            top: controller.showControlsState.value
                ? 0
                : -(48 + padding.top),
            duration: const Duration(milliseconds: 200),
            child: Container(
              height: 48 + padding.top,
              padding: EdgeInsets.only(
                left: padding.left + 12,
                right: padding.right + 12,
                top: padding.top,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black87,
                  ],
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: controller.exitFull,
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  // AppStyle.hGap12,
                  Expanded(
                    child: Text(
                      controller.liveRoom.roomName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  // AppStyle.hGap12,
                  // IconButton(
                  //   onPressed: () {
                  //     controller.saveScreenshot();
                  //   },
                  //   icon: const Icon(
                  //     Icons.camera_alt_outlined,
                  //     color: Colors.white,
                  //     size: 24,
                  //   ),
                  // ),
                  // IconButton(
                  //   onPressed: () {
                  //     showFollowUser(controller);
                  //   },
                  //   icon: const Icon(
                  //     Remix.play_list_2_line,
                  //     color: Colors.white,
                  //     size: 24,
                  //   ),
                  // ),
                  // Visibility(
                  //   visible: Platform.isAndroid,
                  //   child: IconButton(
                  //     onPressed: () {
                  //       controller.enablePIP();
                  //     },
                  //     icon: const Icon(
                  //       Icons.picture_in_picture,
                  //       color: Colors.white,
                  //       size: 24,
                  //     ),
                  //   ),
                  // ),
                  // IconButton(
                  //   onPressed: () {
                  //     showPlayerSettings(controller);
                  //   },
                  //   icon: const Icon(
                  //     Icons.more_horiz,
                  //     color: Colors.white,
                  //     size: 24,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
        // 底部
        Obx(
              () => AnimatedPositioned(
            left: 0,
            right: 0,
            bottom: controller.showControlsState.value
                ? 0
                : -(80 + padding.bottom),
            duration: const Duration(milliseconds: 200),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black87,
                  ],
                ),
              ),
              padding: EdgeInsets.only(
                left: padding.left + 12,
                right: padding.right + 12,
                bottom: padding.bottom,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      controller.refreshRoom();
                    },
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                  ),
                  Offstage(
                    offstage: controller.showDanmakuState.value,
                    child: IconButton(
                      onPressed: () => controller.showDanmakuState.value =
                      !controller.showDanmakuState.value,
                      icon: const ImageIcon(
                        AssetImage('assets/icon/icon_danmaku_open.png'),
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Offstage(
                    offstage: !controller.showDanmakuState.value,
                    child: IconButton(
                      onPressed: () => controller.showDanmakuState.value =
                      !controller.showDanmakuState.value,
                      icon: const ImageIcon(
                        AssetImage('assets/icon/icon_danmaku_close.png'),
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // IconButton(
                  //   onPressed: () {
                  //     showDanmakuSettings(controller);
                  //   },
                  //   icon: const ImageIcon(
                  //     AssetImage('assets/icons/icon_danmaku_setting.png'),
                  //     size: 24,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  const Expanded(child: Center()),
                  // TextButton(
                  //   onPressed: () {
                  //     showQualitesInfo(controller);
                  //   },
                  //   child: Obx(
                  //         () => Text(
                  //       controller.currentQualityInfo.value,
                  //       style: const TextStyle(color: Colors.white, fontSize: 15),
                  //     ),
                  //   ),
                  // ),
                  // TextButton(
                  //   onPressed: () {
                  //     showLinesInfo(controller);
                  //   },
                  //   child: Text(
                  //     controller.currentLineInfo.value,
                  //     style: const TextStyle(color: Colors.white, fontSize: 15),
                  //   ),
                  // ),
                  IconButton(
                    onPressed: () {
                      controller.exitFull();
                    },
                    icon: const Icon(
                      Icons.fullscreen_exit,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildControls(
      bool isPortrait,
      VideoState videoState,
      LiveRoomController controller,
      ) {
    return Stack(
      children: [
        Container(),
        buildDanmuView(videoState, controller),
        // 中间
        Center(
          child: StreamBuilder(
            stream: videoState.widget.controller.player.stream.buffering,
            initialData: videoState.widget.controller.player.state.buffering,
            builder: (_, s) => Visibility(
              visible: s.data ?? false,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: GestureDetector(
            onTap: controller.onTap,
            onDoubleTapDown: controller.onDoubleTap,
            // onVerticalDragStart: controller.onVerticalDragStart,
            // onVerticalDragUpdate: controller.onVerticalDragUpdate,
            // onVerticalDragEnd: controller.onVerticalDragEnd,
            //onLongPress: controller.showDebugInfo,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
            ),
          ),
        ),
        Obx(
              () => AnimatedPositioned(
            left: 0,
            right: 0,
            bottom: controller.showControlsState.value ? 0 : -48,
            duration: const Duration(milliseconds: 200),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black87,
                  ],
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      controller.refreshRoom();
                    },
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                  ),
                  Offstage(
                    offstage: controller.showDanmakuState.value,
                    child: IconButton(
                      onPressed: () => controller.showDanmakuState.value =
                      !controller.showDanmakuState.value,
                      icon: const ImageIcon(
                        AssetImage('assets/icon/icon_danmaku_open.png'),
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Offstage(
                    offstage: !controller.showDanmakuState.value,
                    child: IconButton(
                      onPressed: () => controller.showDanmakuState.value =
                      !controller.showDanmakuState.value,
                      icon: const ImageIcon(
                        AssetImage('assets/icon/icon_danmaku_close.png'),
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const Expanded(child: Center()),

                  IconButton(
                    onPressed: () {
                      controller.enterFullScreen();
                    },
                    icon: const Icon(
                      Icons.fullscreen,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDanmuView(VideoState videoState, LiveRoomController controller) {
    var padding = MediaQuery.of(videoState.context).padding;
    controller.danmakuView ??= DanmakuView(
      key: controller.globalDanmuKey,
      createdController: controller.initDanmakuController,
      option: DanmakuOption(
        fontSize: 16,
      ),
    );
    return Positioned.fill(
      top: padding.top,
      bottom: padding.bottom,
      child: Obx(
            () => Offstage(
          offstage: !controller.showDanmakuState.value,
          child: Padding(
            // padding: controller.fullScreenState.value
            //     ? EdgeInsets.only(
            //   top: AppSettingsController.instance.danmuTopMargin.value,
            //   bottom:
            //   AppSettingsController.instance.danmuBottomMargin.value,
            // )
            //     : EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: controller.danmakuView!,
          ),
        ),
      ),
    );
  }
}
