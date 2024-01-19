import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ChatArea extends StatefulWidget {
  const ChatArea({super.key});

  @override
  ChatAreaState createState() => ChatAreaState();
}

class ChatAreaState extends State<ChatArea> {
  List msgData = []; // 弹幕消息列表

  final ScrollController _chatController = ScrollController(); // 弹幕区滚动Controller

  @override
  void initState() {
    super.initState();
    var s = {
      'lv': 0,
      'name': '系统消息',
      'text': '欢迎来到直播间',
    };
    msgData = [s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s];
    // SocketClient.create();
    // var channel = SocketClient.channel;
    // // 接受弹幕、礼物消息(webSocket)
    // channel.stream.listen((message) {
    //   message = json.decode(message);
    //   var sign = message[0];
    //   var data = message[1];
    //   if (sign == 'getChat') {
    //     if (mounted)
    //       setState(() {
    //         msgData.add(data);
    //       });
    //     _chatController.jumpTo(_chatController.position.maxScrollExtent);
    //   }
    // });
  }

  @override
  void dispose() {
    // SocketClient.channel?.sink?.close(status.goingAway);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _chatController.animateTo(_chatController.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    });
    return ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.15],
            colors: [
              Colors.black, Colors.transparent
            ],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstOut,
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(color: Color(0xffeeeeee), width: 0),
                bottom: BorderSide(color: Colors.white, width: 0)
            ),
          ),
          child: ListView.builder(
              controller: _chatController,
              itemCount: msgData.length,
              itemBuilder: (context, index) {
                return _chatMsg()[index];
              }
          )
        )
    );
  }

  List<Widget> _chatMsg() {
    List<Widget> msgList = [];
    for (var item in msgData) {
      var isAdmin = item['lv'] > 0;
      var msgBoart = RichText(
        strutStyle: const StrutStyle(
            leading: 3.5 / 15,
            height: 1
        ),
        text: TextSpan(
            style: const TextStyle(
              color: Color(0xff666666),
              fontSize: 15,
            ),
            children: [
              WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Text("LV${item['lv']}", style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12
                    )),
                  )
              ),
              TextSpan(
                text: '${item['name']}: ',
                style: TextStyle(
                    color: !isAdmin ? Colors.blue : const Color(0xff999999)
                ),
              ),
              TextSpan(
                text: item['text'],
              ),
            ]
        ),
      );

      msgList.addAll([
        msgBoart,
        const Padding(padding: EdgeInsets.only(bottom: 5))
      ]);
    }
    return msgList;
  }
}