import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_barrage/flutter_barrage.dart';

class LiveRoomPage extends StatefulWidget {
  const LiveRoomPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage> {

  final barrageWallController = BarrageWallController();
  Random random = Random();
  final textEditingController = TextEditingController();
  late List<Bullet> bullets;

  @override
  void initState() {
    super.initState();
    bullets = List<Bullet>.generate(1000, (i) {
      final showTime = random.nextInt(60000); // in 60s
      return Bullet(child: Text('$i-$showTime'), showTime: showTime);
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
              child: Container(
                color: Colors.pink,
                child: Stack(children: <Widget>[
                  Positioned(
                      top: 10,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: MediaQuery
                          .of(context)
                          .size
                          .width *
                          MediaQuery
                              .of(context)
                              .size
                              .aspectRatio +
                          100,
                      //视频播放
                      child: Container()),
                  Positioned(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width *
                          MediaQuery.of(context).size.aspectRatio +
                          100,
                      child: BarrageWall(
                          debug: true,
                          safeBottomHeight:
                          60,
                          bullets: bullets,
                          controller: barrageWallController,
                          child: Container())),
                ]),
              ),
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