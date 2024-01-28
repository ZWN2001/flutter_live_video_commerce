
import 'package:flutter/cupertino.dart';
import 'package:live_video_commerce/entity/live_room.dart';

import 'package:live_video_commerce/ui/page/live/player_controller.dart';
import 'package:video_player/video_player.dart';

import '../../../entity/commodity.dart';
import '../../../entity/commodity_specification.dart';

class LiveRoomController extends PlayerController with WidgetsBindingObserver{

  late LiveRoom liveRoom;

  late List<Commodity> commodities;
  late Future<void> initializeVideoPlayerFuture;
  late VideoPlayerController videoPlayerController;
  final TextEditingController barrageEditingController =
  TextEditingController();


  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    // _bulletsStart();

    videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',));
    initializeVideoPlayerFuture = videoPlayerController.initialize();

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
  }

  void refreshRoom() {
    // superChats.clear();
    // liveDanmaku.stop();
    //
    // loadData();
  }

}