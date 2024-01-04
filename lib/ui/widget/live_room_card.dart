import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_commerce/entity/live_room.dart';

import '../page/live/live_room_page.dart';

//直播间展示卡片
class LiveRoomCard extends StatelessWidget {
  final LiveRoomMini liveRoom;
  final double width;

  const LiveRoomCard({Key? key, required this.liveRoom, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blue,
      padding: const EdgeInsets.all(2),
      child: GestureDetector(
          child: Stack(
            children: [
              Positioned(
                top: 0, left: 0,
                child: SizedBox(width: width ,child: Image.network(liveRoom.coverUrl, fit: BoxFit.fitWidth,),),),
              Positioned(
                bottom: 4, left: 4,
                child: Text(liveRoom.anchorName),),
              Positioned(
                  bottom: 4, right: 4,
                  child: Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: Colors.white,),
                      Text(liveRoom.onlineCount.toString()),
                    ],
                  )),
            ],
          ),
          // child: Column(
          //   children: [
          //
          //     Row(
          //       children: [
          //         const SizedBox(width: 8,),
          //         Text(liveRoom.title, overflow: TextOverflow.ellipsis,),
          //         const Expanded(child: SizedBox(),),
          //         if(liveRoom.roomSectionName != "")
          //           Text(liveRoom.roomSectionName, style: const TextStyle(color: Colors.grey),),
          //       ],
          //     )
          //   ],
          // ),
          onTap: () {
            Get.to(() => LiveRoomPage(roomid: liveRoom.roomId));
          }
      ),
    );
  }
}