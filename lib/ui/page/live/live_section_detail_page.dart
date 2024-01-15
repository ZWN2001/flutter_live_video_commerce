import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:get/get.dart';
import 'package:live_video_commerce/utils/constant_string_utils.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

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
  final RefreshController _refreshController = RefreshController(initialRefresh: false);


  final double imgRatio = 9/16;
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        // primary: false,
        physics: const ClampingScrollPhysics(),
        // scrollController: ScrollController(),
        header: ConstantStringUtils.classicHeader,
        footer: ConstantStringUtils.classicFooter,
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child:  ListView(
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
              //禁用滑动事件
              scrollDirection: Axis.vertical,
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
      ),
    );
  }

  Future<void> _fetchData() async {
    _swiperImageUrlList = [];
    LiveRoomMini mini = LiveRoomMini(
    rid: "1",
    roomName: "title",
    coverUrl: "https://live-cover.msstatic.com/huyalive/1199533567890-1199533567890-5315847976780824576-2399067259236-10057-A-0-1/20240104140701.jpg",
    anchorName: "anchorName",
    onlineCount: 1,
    );
    _liveRoomMiniList = [mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,mini,];
  }

  void _onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    await Future.delayed(Duration(milliseconds: 1000));
    if(mounted)
      setState(() {});
    _refreshController.loadComplete();
  }

}