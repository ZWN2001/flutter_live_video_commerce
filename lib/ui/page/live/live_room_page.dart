import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_barrage/flutter_barrage.dart';
import 'package:get/get.dart';
import 'package:live_video_commerce/entity/live_room.dart';
import 'package:video_player/video_player.dart';

import '../../../utils/stroke_text_widget.dart';

class LiveRoomPage extends StatefulWidget {
  final int roomid;
  const LiveRoomPage({Key? key, required this.roomid}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage> with  TickerProviderStateMixin {

  final barrageWallController = BarrageWallController();
  Random random = Random();
  final textEditingController = TextEditingController();
  late List<Bullet> bullets;
  late VideoPlayerController _videoPlayerController;
  TextStyle ts = const TextStyle(
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
      return Bullet(child: StrokeTextWidget('$i-$showTime',textStyle: ts,), showTime: showTime);
    });

    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
        'http://202.194.15.142:7001/live/movie.flv'))
      ..initialize().then((_) {
        _videoPlayerController.play();
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("直播demo")),
        floatingActionButton: Switch(
          value: barrageWallController.isEnabled,
          onChanged: (updateTo) {
            barrageWallController.isEnabled
                ? barrageWallController.disable()
                : barrageWallController.enable();
            setState(() {});
          },
        ),
        body: SafeArea(
          child: Column(children: <Widget>[
            Expanded(
              flex: 9,
              child: Stack(children: <Widget>[
                // Positioned(
                //     top: 10,
                //     width: Get.width,
                //     height: Get.width * Get.size.aspectRatio + 100,
                //     //视频播放
                //     child: VideoPlayer(_videoPlayerController)),
                Positioned(
                    top: 14,
                      width: Get.width,
                      height: Get.width * Get.size.aspectRatio + 92,
                  child: BarrageWall(
                      debug: true,
                      safeBottomHeight:
                      60,
                      bullets: bullets,
                      controller: barrageWallController,
                      child: Container()),
                ),
              ]),
            ),
            ElevatedButton(
                onPressed: () => barrageWallController.clear(),
                child: const Text('清空弹幕')),
            Expanded(
              child: TextField(
                controller: textEditingController,
                maxLength: 20,
                onSubmitted: (text) {
                  barrageWallController
                      .send([Bullet(child: Text(text))]);
                  textEditingController.clear();
                },
              ),
            ),
          ]),
        ));
  }
}