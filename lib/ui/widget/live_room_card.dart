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
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        //圆角
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
        ),
        child: GestureDetector(
            child: Stack(
              children: [
                Positioned(
                  top: 0, left: 0,
                  child: SizedBox(width: width, height: width * 0.62, child: Image.network(liveRoom.coverUrl, fit: BoxFit.fitWidth,),),),
                Positioned(
                  bottom: 2, left: 4,
                  child: Text(liveRoom.roomName,overflow: TextOverflow.ellipsis,),),
                // Positioned(
                //     bottom: 4, right: 4,
                //     child: Row(
                //       children: [
                //         const Icon(Icons.person, size: 16, color: Colors.black54,),
                //         Text(liveRoom.onlineCount.toString()),
                //       ],
                //     )),
              ],
            ),
            onTap: () {
              Get.to(() => const LiveRoomPage(),arguments: liveRoom.rid);
            }
        ),
      ),
    );
  }
}