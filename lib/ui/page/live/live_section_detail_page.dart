import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:get/get.dart';

import '../../../entity/live_room.dart';
import '../../../entity/section.dart';
import '../../widget/live_room_card.dart';

class LiveSectionDetailPage extends StatefulWidget{
  final Section section;
  const LiveSectionDetailPage({super.key,required this.section});

  @override
  State<StatefulWidget> createState() => LiveSectionDetailPageState();

}

class LiveSectionDetailPageState extends State<LiveSectionDetailPage>{
  List<String> _swiperImageUrlList = [];
  List<LiveRoomMini> _liveRoomMiniList = [];
  final double imgRatio = 9/16;
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          if(_swiperImageUrlList.isNotEmpty)
          Swiper(
            itemBuilder: (context, index) {
              return Image.network(
                _swiperImageUrlList[index],
                fit: BoxFit.fitWidth,
              );
            },
            autoplay: true,
            itemCount: _swiperImageUrlList.length,
            pagination:
            const SwiperPagination(builder: SwiperPagination.rect),
            control: const SwiperControl(),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _liveRoomMiniList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.4 ,
            ),
            itemBuilder: (context, index) {
              return LiveRoomCard(liveRoom: _liveRoomMiniList[index],width: Get.width/2,);
            },
          )
        ],
      ),
    );
  }

  Future<void> _fetchData() async {
    _swiperImageUrlList = [];
    LiveRoomMini mini = LiveRoomMini(
    roomId: 1,
    title: "title",
    coverUrl: "https://live-cover.msstatic.com/huyalive/1199533567890-1199533567890-5315847976780824576-2399067259236-10057-A-0-1/20240104140701.jpg",
    anchorName: "anchorName",
    onlineCount: 1,
    status: 1,
    roomSectionName: "roomSectionName",
    );
    _liveRoomMiniList = [mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,];
  }

}