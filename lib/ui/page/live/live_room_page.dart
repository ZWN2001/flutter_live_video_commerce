import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_barrage/flutter_barrage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

// import 'package:live_video_commerce/entity/live_room.dart';
import 'package:live_video_commerce/ui/widget/live_room_chat_area.dart';
import 'package:video_player/video_player.dart';

import '../../../utils/stroke_text_widget.dart';

class LiveRoomPage extends StatefulWidget {
  final int roomid;

  const LiveRoomPage({Key? key, required this.roomid}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage>
    with TickerProviderStateMixin {
  final _barrageWallController = BarrageWallController();
  Random random = Random();
  final _textEditingController = TextEditingController();
  late List<Bullet> bullets;
  late VideoPlayerController _videoPlayerController;
  final TextEditingController _barrageEditingController =
      TextEditingController();
  bool _isVideoControlAreaShowing = false;
  bool _isBarrageShowing = false;
  bool _isFullScreen = false;
  TextStyle barrageTextStyle = const TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.none,
  );

  @override
  void initState() {
    super.initState();
    bullets = List<Bullet>.generate(1000, (i) {
      final showTime = random.nextInt(60000); // in 60s
      return Bullet(
          child: StrokeTextWidget(
            '$i-$showTime',
            textStyle: barrageTextStyle,
          ),
          showTime: showTime);
    });

    _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse('http://202.194.15.142:7001/live/movie.flv'))
      ..initialize().then((_) {
        _videoPlayerController.play();
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("直播")),
        // floatingActionButton: Switch(
        //   value: barrageWallController.isEnabled,
        //   onChanged: (updateTo) {
        //     barrageWallController.isEnabled
        //         ? barrageWallController.disable()
        //         : barrageWallController.enable();
        //     setState(() {});
        //   },
        // ),
        body: Column(children: <Widget>[
          SizedBox(
            height: Get.width * Get.size.aspectRatio + 90,
            child: videoArea(),
          ),
          const Expanded(child: ChatArea()),
          // ElevatedButton(
          //     onPressed: () => barrageWallController.clear(),
          //     child: const Text('清空弹幕')),
          const SizedBox(
            height: 8,
          ),
          _bottomArea(),
          const SizedBox(
            height: 8,
          )
        ]));
  }

  Widget videoArea() {
    return Stack(children: <Widget>[
      Positioned(
          top: 0,
          child: Column(
            children: [
              Container(
                width: Get.width,
                height: Get.width * Get.size.aspectRatio + 90,
                color: Colors.blue,
              ),
              // const ChatArea()
            ],
          )),
      Positioned(
        top: 14,
        width: Get.width,
        height: Get.width * Get.size.aspectRatio + 92,
        child: BarrageWall(
            debug: false,
            safeBottomHeight: 60,
            bullets: bullets,
            controller: _barrageWallController,
            child: Container()),
      ),
      Positioned(
        top: 0,
        width: Get.width,
        height: Get.width * Get.size.aspectRatio + 90,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _isVideoControlAreaShowing = !_isVideoControlAreaShowing;
            });
          },
          child: _isVideoControlAreaShowing
              ? videoPlayerControlArea()
              : Container(
                  color: Colors.transparent,
                ),
        ),
      )
    ]);
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

  Widget videoPlayerControlArea() {
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

                      if (_isBarrageShowing)
                        GestureDetector(
                          child: SvgPicture.asset("assets/icon/barrage_off.svg",
                              width: 24, height: 24,
                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),),
                          onTap: () {
                            setState(() {
                              _isBarrageShowing = false;
                              _barrageWallController.clear();
                            });
                          },
                        ),

                      if (!_isBarrageShowing)
                        GestureDetector(
                          child: SvgPicture.asset("assets/icon/barrage_on.svg",
                              width: 24, height: 24,
                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),),
                          onTap: () {
                            setState(() {
                              _isBarrageShowing = true;
                            });
                          },
                        ),

                      const SizedBox(
                        width: 10,
                      ),

                      if (!_isFullScreen)
                        IconButton(
                          icon: const Icon(
                            Icons.fullscreen,
                            color: Colors.white,
                            size: 24.0,
                          ),
                          onPressed: () {
                            setState(() {
                              _isFullScreen = true;
                            });
                          },
                        ),

                      if (_isFullScreen)
                        IconButton(
                          icon: const Icon(
                            Icons.fullscreen_exit,
                            color: Colors.white,
                            size: 24.0,
                          ),
                          onPressed: () {
                            setState(() {
                              _isFullScreen = false;
                            });
                          },
                        ),
                    ],
                  ),
                ],
              ))),
    );
  }
}
