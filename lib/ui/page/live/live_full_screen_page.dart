import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barrage/flutter_barrage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../utils/stroke_text_widget.dart';


class LiveFullScreenPage extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  const LiveFullScreenPage({super.key, required this.videoPlayerController});

  @override
  LiveFullScreenPageState createState() => LiveFullScreenPageState();
}

class LiveFullScreenPageState extends State<LiveFullScreenPage> {

  final _barrageWallController = BarrageWallController();
  Random random = Random();
  late List<Bullet> bullets;
  // late VideoPlayerController _videoPlayerController;
  final TextEditingController _barrageEditingController =
  TextEditingController();
  bool _isVideoControlAreaShowing = false;
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

  Future<void> _fetchData() async {
    _bulletsStart();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    final size =MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      child: Stack(
        children: [
          Positioned(
            left: 32,
            height: size.height,
            child: _videoArea(),
          ),
          Positioned(
            top: 14,
            width: Get.width,
            height: size.height,
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
            height: size.height,
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
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Widget _videoArea(){
    return AspectRatio(
      aspectRatio: widget.videoPlayerController.value.aspectRatio,
      child: VideoPlayer(widget.videoPlayerController),
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
              stops: [0.85, 1],
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
                      widget.videoPlayerController.value.isPlaying
                          ? IconButton(
                        icon: const Icon(
                          Icons.pause,
                          color: Colors.white,
                          size: 24.0,
                        ),
                        onPressed: () {
                          setState(() {
                            widget.videoPlayerController.pause();
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
                            widget.videoPlayerController.play();
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
                          Get.back();
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
                  const SizedBox(height: 4,)
                ],
              ))),
    );
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