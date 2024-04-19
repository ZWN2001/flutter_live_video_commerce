
import 'package:flutter/cupertino.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:live_video_commerce/api/api.dart';
import 'package:live_video_commerce/entity/live_room.dart';

import 'package:live_video_commerce/ui/page/live/player_controller.dart';
import 'package:media_kit/media_kit.dart';

import '../../../entity/commodity/commodity.dart';

import '../../../entity/commodity/commodity_specification.dart';
import '../../../entity/result.dart';

class LiveRoomController extends PlayerController with WidgetsBindingObserver{

  LiveRoom liveRoom = LiveRoom.empty();

  final List<Commodity> commodities = [];

  final TextEditingController barrageEditingController =
  TextEditingController();


  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    fetchData();
    update();
  }

  void refreshRoom() {
    // superChats.clear();
    // liveDanmaku.stop();
    //
    // loadData();
  }

  Future<void> fetchData() async {
    int rid = Get.arguments;

    ResultEntity<LiveRoom> result = await LiveRoomAPI.getLiveRoomInfo(rid);
    if(result.success) {
      liveRoom = result.data!;
      player.open(
        Media(liveRoom.liveUrl),
      );
    } else {
      Get.snackbar("直播间加载失败", result.message);
    }

    ResultEntity<List<Commodity>> commodityResult = await CommodityAPI.getCommodities(rid);
    if(commodityResult.success) {
      commodities.clear();
      commodities.addAll(commodityResult.data!);
      print(commodities);
    }

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