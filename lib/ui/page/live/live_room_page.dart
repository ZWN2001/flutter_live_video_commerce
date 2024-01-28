import 'dart:math';

import 'package:flutter/material.dart';
// import 'package:flutter_barrage/flutter_barrage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:live_video_commerce/entity/commodity.dart';

import 'package:live_video_commerce/ui/widget/live_room_chat_area.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:ns_danmaku/danmaku_controller.dart';
import 'package:ns_danmaku/danmaku_view.dart';
import 'package:ns_danmaku/models/danmaku_item.dart';
import 'package:ns_danmaku/models/danmaku_option.dart';
import 'package:video_player/video_player.dart';

import '../../../entity/commodity_specification.dart';
import '../../widget/show_commodities_list_sheet.dart';
import 'live_controller.dart';

class LiveRoomPage extends StatefulWidget {
  final String roomid;

  const LiveRoomPage({Key? key, required this.roomid}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage>
    with TickerProviderStateMixin {
  Random random = Random();
  late List<Commodity> commodities;
  late Future<void> _initializeVideoPlayerFuture;
  bool showDanmakuState = false;
  late VideoPlayerController _videoPlayerController;
  final TextEditingController _barrageEditingController =
      TextEditingController();
  DanmakuController? danmakuController;
  bool _isDanmakuShowing = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("直播")),
        floatingActionButton: _commodityButtons(),
        body: Column(children: <Widget>[
          SizedBox(
            width: Get.width,
            child: Stack(
              children: [
                _videoArea(),
                Positioned(
                    top: 14,
                    width: Get.width,
                    height: Get.width * Get.size.aspectRatio + 60,
                    child: DanmakuView(
                      key: UniqueKey(),
                      createdController: (controller) {
                        danmakuController = controller;
                      },
                      option: DanmakuOption(
                        fontSize: 16,
                      ),
                    )
                ),
                Positioned(
                  top: 0,
                  width: Get.width,
                  height: Get.width * Get.size.aspectRatio + 50,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showDanmakuState =
                        !showDanmakuState;
                      });
                    },
                    child: showDanmakuState
                        ? _videoPlayerControlArea()
                        : Container(
                      color: Colors.transparent,
                    ),
                  ),
                )
              ],
            ),
          ),
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

  Widget _videoArea(){
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: _videoPlayerController.value.aspectRatio,
            child: VideoPlayer(_videoPlayerController),
          );
        } else {
          return SizedBox(
            height: Get.width * Get.size.aspectRatio + 50,
            child: const Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget _bottomArea() {
    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextField(
            controller: _barrageEditingController,
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
            if (_barrageEditingController.text.isEmpty) return;
            _addDanmaku([
              DanmakuItem(
              _barrageEditingController.text,
            ),]);
            _barrageEditingController.clear();
          },
        )
      ],
    );
  }

  Widget _videoPlayerControlArea() {
    return Align(
      alignment: Alignment.topLeft,
      child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.8, 1],
              colors: [
                Color.fromRGBO(0, 0, 0, 0),
                Color.fromRGBO(0, 0, 0, 0.8),
              ],
            ).createShader(bounds);
          },
          blendMode: BlendMode.color,
          child: Container(
              decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(color: Color(0xffeeeeee), width: 0),
                    bottom: BorderSide(color: Colors.white, width: 0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      _videoPlayerController.value.isPlaying
                          ? IconButton(
                              icon: const Icon(
                                Icons.pause,
                                color: Colors.white,
                                size: 24.0,
                              ),
                              onPressed: () {
                                setState(() {
                                  _videoPlayerController.pause();
                                });
                              },
                            )
                          : IconButton(
                              icon: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 24.0,
                              ),
                              onPressed: () {
                                setState(() {
                                  _videoPlayerController.play();
                                });
                              },
                            ),

                      const Expanded(child: SizedBox()),

                      if (!_isDanmakuShowing)
                        GestureDetector(
                          child: SvgPicture.asset("assets/icon/barrage_off.svg",
                              width: 24, height: 24,
                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),),
                          onTap: () {
                            _bulletsStart();

                          },
                        ),

                      if (_isDanmakuShowing)
                        GestureDetector(
                          child: SvgPicture.asset("assets/icon/barrage_on.svg",
                              width: 24, height: 24,
                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),),
                          onTap: () {
                            _bulletsStop();
                          },
                        ),

                      const SizedBox(
                        width: 10,
                      ),
                        IconButton(
                          icon: const Icon(
                            Icons.fullscreen,
                            color: Colors.white,
                            size: 24.0,
                          ),
                          onPressed: () {
                            // Get.to(() => LiveFullScreenPage(videoPlayerController: _videoPlayerController,));
                          },
                        ),

                      // if (_isFullScreen)
                      //   IconButton(
                      //     icon: const Icon(
                      //       Icons.fullscreen_exit,
                      //       color: Colors.white,
                      //       size: 24.0,
                      //     ),
                      //     onPressed: () {
                      //       setState(() {
                      //         _isFullScreen = false;
                      //       });
                      //     },
                      //   ),
                    ],
                  ),
                ],
              ))),
    );
  }

  Widget _commodityButtons(){
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
                ShowCommoditiesListSheet.showCommoditiesListSheet(context, commodities);
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

  Future<void> _fetchData() async {
    _bulletsStart();

    _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',));
    _initializeVideoPlayerFuture = _videoPlayerController.initialize();

    CommoditySpecification commoditySpecification = CommoditySpecification(
      cid: "1",
      id: "1",
      imageUrl: "https://www.zwn2001.space/img/favicon.webp",
      specification: "Sample Specification",
      price: 9.99,
    );

    Commodity testCommodity = Commodity(
      cid: "123",
      commodityName: "测试商品",
      anchorId: "456",
      anchorName: "测试主播",
      price: 9.99,
      freight: 2.99,
      specification: [commoditySpecification,commoditySpecification],
      imageUrl: ["https://www.zwn2001.space/img/favicon.webp"],
    );

    commodities=[testCommodity,testCommodity,testCommodity];
  }

  void _bulletsStart() {
    if(!_isDanmakuShowing){
      _isDanmakuShowing = true;
       danmakuController?.resume();
      if(mounted){setState(() {});}
    }
  }

  void _bulletsStop() {
    if(_isDanmakuShowing){
      _isDanmakuShowing = false;
      danmakuController?.pause();
      if(mounted){setState(() {});}
    }
  }

  void _addDanmaku(List<DanmakuItem> items) {
    //todo:api
    if (!_isDanmakuShowing) {
      return;
    }
    danmakuController?.addItems(items);
  }
}
