import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_barrage/flutter_barrage.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

// import 'package:live_video_commerce/entity/live_room.dart';
import 'package:live_video_commerce/ui/widget/live_room_chat_area.dart';
import 'package:video_player/video_player.dart';

import '../../../utils/stroke_text_widget.dart';
import 'live_full_screen_page.dart';

class LiveRoomPage extends StatefulWidget {
  final String roomid;

  const LiveRoomPage({Key? key, required this.roomid}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage>
    with TickerProviderStateMixin {
  final _barrageWallController = BarrageWallController();
  Random random = Random();
  List<Bullet> bullets = [];
  late Future<void> _initializeVideoPlayerFuture;
  late StateSetter _reloadSpeedDialState;
  bool _isVideoControlAreaShowing = false;
  late VideoPlayerController _videoPlayerController;
  final TextEditingController _barrageEditingController =
      TextEditingController();
  bool _isBarrageShowing = false;
  TextStyle barrageTextStyle = const TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.none,
  );

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("直播")),
        floatingActionButton: StatefulBuilder(
          builder: (context, setState) {
            _reloadSpeedDialState = setState;
            return const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                // _videoPlayerControlArea(),
                SizedBox(
                  height: 48,
                ),
              ],
            );
          },
        ),
        body: Column(children: <Widget>[
           SizedBox(
             width: Get.width,
             child: Stack(
               children: [
                 _videoArea(),
                 if(_isBarrageShowing)
                   Visibility(
                     visible: _isBarrageShowing,
                     child: Positioned(
                       top: 14,
                       width: Get.width,
                       height: Get.width * Get.size.aspectRatio + 40,
                       child: BarrageWall(
                           debug: false,
                           safeBottomHeight: 60,
                           bullets: bullets,
                           controller: _barrageWallController,
                           child: Container()),
                     ),
                   ),
                     Positioned(
                       top: 0,
                       width: Get.width,
                       height: Get.width * Get.size.aspectRatio + 50,
                       child: GestureDetector(
                         onTap: () {
                           setState(() {
                             _isVideoControlAreaShowing = !_isVideoControlAreaShowing;
                           });
                         },
                         child: _isVideoControlAreaShowing
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

  // Widget _videoArea() {
  //   return Stack(children: <Widget>[
  //     Positioned(
  //         top: 0,
  //         child: Column(
  //           children: [
  //             Container(
  //               width: Get.width,
  //               height: Get.width * Get.size.aspectRatio + 90,
  //               color: Colors.blue,
  //             ),
  //             // const ChatArea()
  //           ],
  //         )),
  //     Positioned(
  //       top: 14,
  //       width: Get.width,
  //       height: Get.width * Get.size.aspectRatio + 92,
  //       child: BarrageWall(
  //           debug: false,
  //           safeBottomHeight: 60,
  //           bullets: bullets,
  //           controller: _barrageWallController,
  //           child: Container()),
  //     ),
  //     Positioned(
  //       top: 0,
  //       width: Get.width,
  //       height: Get.width * Get.size.aspectRatio + 90,
  //       child: GestureDetector(
  //         onTap: () {
  //           setState(() {
  //             _isVideoControlAreaShowing = !_isVideoControlAreaShowing;
  //           });
  //         },
  //         child: _isVideoControlAreaShowing
  //             ? videoPlayerControlArea()
  //             : Container(
  //                 color: Colors.transparent,
  //               ),
  //       ),
  //     )
  //   ]);
  // }

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
            _barrageWallController.send([
              Bullet(
                  child: StrokeTextWidget(
                    _barrageEditingController.text,
                    textStyle: barrageTextStyle,
                  ),
                  showTime: 0)
            ]);
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

                      if (!_isBarrageShowing)
                        GestureDetector(
                          child: SvgPicture.asset("assets/icon/barrage_off.svg",
                              width: 24, height: 24,
                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),),
                          onTap: () {
                            _bulletsStart();

                          },
                        ),

                      if (_isBarrageShowing)
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
                            Get.to(() => LiveFullScreenPage(videoPlayerController: _videoPlayerController,));
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
  //
  // Widget _videoPlayerControlArea(){
  //   return SpeedDial(
  //     key: const ValueKey(0),
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.all(Radius.circular(16)),
  //     ),
  //     spacing: 16,
  //     animationCurve: Curves.elasticInOut,
  //     childMargin: EdgeInsets.zero,
  //     childPadding: const EdgeInsets.all(8.0),
  //     childrenButtonSize: const Size(64, 64),
  //     animatedIcon: AnimatedIcons.menu_close,
  //     closeManually: true,
  //     children: [
  //       _videoPlayerController.value.isPlaying
  //           ? SpeedDialChild(
  //           shape: const RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(12)),
  //           ),
  //           child: Icon(
  //             Icons.pause,
  //             color: Get.theme.colorScheme.primary,
  //           ),
  //           // label: '暂停',
  //           labelBackgroundColor: Get.theme.colorScheme.primary,
  //           labelStyle: TextStyle(color: Get.theme.colorScheme.onPrimary),
  //           onTap: () {
  //             setState(() {
  //               _videoPlayerController.pause();
  //             });
  //           })
  //           : SpeedDialChild(
  //           shape: const RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(12)),
  //           ),
  //           child: Icon(
  //             Icons.play_arrow,
  //             color: Get.theme.colorScheme.primary,
  //           ),
  //           labelBackgroundColor: Get.theme.colorScheme.primary,
  //           labelStyle: TextStyle(color: Get.theme.colorScheme.onPrimary),
  //           onTap: () {
  //             setState(() {
  //               _videoPlayerController.play();
  //             });
  //           }),
  //
  //       _isBarrageShowing?
  //
  //       SpeedDialChild(
  //           shape: const RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(12)),
  //           ),
  //           child: SvgPicture.asset("assets/icon/barrage_off.svg",
  //             width: 24, height: 24,
  //             colorFilter: ColorFilter.mode(Get.theme.colorScheme.primary, BlendMode.srcIn),),
  //           labelBackgroundColor: Get.theme.colorScheme.primary,
  //           labelStyle: TextStyle(color: Get.theme.colorScheme.onPrimary),
  //           onTap: () {
  //             _bulletsStop();
  //             _reloadSpeedDialState;
  //           })
  //           :
  //       SpeedDialChild(
  //           shape: const RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(12)),
  //           ),
  //           child: SvgPicture.asset("assets/icon/barrage_on.svg",
  //             width: 24, height: 24,
  //             colorFilter: ColorFilter.mode(Get.theme.colorScheme.primary, BlendMode.srcIn),),
  //           labelBackgroundColor: Get.theme.colorScheme.primary,
  //           labelStyle: TextStyle(color: Get.theme.colorScheme.onPrimary),
  //           onTap: () {
  //             _bulletsStart();
  //             _reloadSpeedDialState;
  //           }),
  //       SpeedDialChild(
  //           shape: const RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(12)),
  //           ),
  //           child: Icon(
  //              Icons.star_border_rounded,
  //             color: Get.theme.colorScheme.primary,
  //           ),
  //           labelBackgroundColor: Get.theme.colorScheme.primary,
  //           labelStyle: TextStyle(color: Get.theme.colorScheme.onPrimary),
  //           onTap: () async {
  //             if (mounted) {
  //               setState(() {
  //                 // _isFavor = !_isFavor;
  //               });
  //             }
  //
  //           })
  //     ],
  //   );
  // }



  Future<void> _fetchData() async {
    _bulletsStart();

    _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',));
    _initializeVideoPlayerFuture = _videoPlayerController.initialize();
  }

  void _bulletsStart() {
    if(!_isBarrageShowing){
      _isBarrageShowing = true;
      bullets = List<Bullet>.generate(1000, (i) {
        final showTime = random.nextInt(60000); // in 60s
        return Bullet(
            child: StrokeTextWidget(
              '$i-$showTime',
              textStyle: barrageTextStyle,
            ),
            showTime: showTime);
      });
      if(mounted){
        setState(() {});
      }
    }
  }

  void _bulletsStop() {
    if(_isBarrageShowing){
      _isBarrageShowing = false;
      _barrageWallController.clear();
      _barrageWallController.disable();
      bullets.clear();
      if(mounted){
        setState(() {});
      }
    }
  }
}
