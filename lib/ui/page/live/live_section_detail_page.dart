import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:get/get.dart';
import 'package:live_video_commerce/api/api.dart';
import 'package:live_video_commerce/entity/result.dart';
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
        physics: const ClampingScrollPhysics(),
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
              scrollDirection: Axis.vertical,
              itemCount: _liveRoomMiniList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.3 ,
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
    ResultEntity<List<LiveRoomMini>> result = await LiveRoomAPI.getLiveRooms(widget.section.sid);
    if(result.success){
      _liveRoomMiniList = result.data!;
    }
  }

  void _onRefresh() async{
    _liveRoomMiniList.clear();
    await _fetchData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    //TODO:load more
    await Future.delayed(Duration(milliseconds: 1000));
    if(mounted)
      setState(() {});
    _refreshController.loadComplete();
  }

}