
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:live_video_commerce/entity/live_room.dart';

import 'package:live_video_commerce/ui/page/live/player_controller.dart';
import 'package:media_kit/media_kit.dart';
import 'package:video_player/video_player.dart';

import '../../../entity/commodity.dart';
import '../../../entity/commodity_specification.dart';

class LiveRoomController extends PlayerController with WidgetsBindingObserver{

  late Rx<LiveRoom> liveRoom;

  late List<Commodity> commodities;
  late Future<void> initializeVideoPlayerFuture;

  final TextEditingController barrageEditingController =
  TextEditingController();


  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    fetchData();
  }

  void refreshRoom() {
    // superChats.clear();
    // liveDanmaku.stop();
    //
    // loadData();
  }

  Future<void> fetchData() async {
    // bulletsStart();
    CommoditySpecification commoditySpecification = CommoditySpecification(
      cid: "1",
      id: "1",
      imageUrl: "https://www.zwn2001.space/img/favicon.webp",
      specification: "Sample Specification",
      price: 9.99,
    );

    Commodity testCommodity = Commodity(
      cid: "123",
      commodityName: "测试商品",
      anchorId: "456",
      anchorName: "测试主播",
      price: 9.99,
      freight: 2.99,
      specification: [commoditySpecification,commoditySpecification],
      imageUrl: ["https://www.zwn2001.space/img/favicon.webp"],
    );

    commodities=[testCommodity,testCommodity,testCommodity];

    liveRoom = LiveRoom(
      rid: "123",
      uid: "456",
      sectionId: 1,
      roomName: "测试直播间",
      liveUrl: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
      coverUrl: "https://www.zwn2001.space/img/favicon.webp",
      description: "测试直播间",
      status: 0,
    ).obs;

    player.open(
      Media(liveRoom.value.liveUrl),
    );

  }

  // void bulletsStart() {
  //   if(!showDanmakuState.value){
  //     showDanmakuState.value = true;
  //     danmakuController?.resume();
  //   }
  // }
  //
  // void bulletsStop() {
  //   if(showDanmakuState.value){
  //     showDanmakuState.value = false;
  //     danmakuController?.pause();
  //   }
  // }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    danmakuController = null;
    super.onClose();
  }

}