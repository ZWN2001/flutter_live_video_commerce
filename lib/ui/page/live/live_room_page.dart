import 'dart:math';

import 'package:flutter/material.dart';
// import 'package:flutter_barrage/flutter_barrage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:live_video_commerce/entity/commodity.dart';

import 'package:live_video_commerce/ui/widget/live_room_chat_area.dart';
import 'package:ns_danmaku/danmaku_controller.dart';
import 'package:ns_danmaku/danmaku_view.dart';
import 'package:ns_danmaku/models/danmaku_item.dart';
import 'package:ns_danmaku/models/danmaku_option.dart';
import 'package:video_player/video_player.dart';

import '../../../entity/commodity_specification.dart';
import '../../widget/show_commodities_list_sheet.dart';
import 'live_full_screen_page.dart';

class LiveRoomPage extends StatefulWidget {
  final String roomid;

  const LiveRoomPage({Key? key, required this.roomid}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage>
    with TickerProviderStateMixin {
  Random random = Random();
  late List<Commodity> commodities;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isVideoControlAreaShowing = false;
  late VideoPlayerController _videoPlayerController;
  final TextEditingController _barrageEditingController =
      TextEditingController();
  DanmakuController? danmakuController;
  bool _isDanmakuShowing = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("直播")),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue,
              child: IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.shopping_bag_outlined),
                  onPressed: () {
                    ShowCommoditiesListSheet.showCommoditiesListSheet(context, commodities);
                  }
              ),
            ),
            const SizedBox(
              height: 48,
            ),
          ],
        ),
        body: Column(children: <Widget>[
          SizedBox(
            width: Get.width,
            child: Stack(
              children: [
                _videoArea(),
                if(_isDanmakuShowing)
                  Visibility(
                    visible: _isDanmakuShowing,
                    child: Positioned(
                      top: 14,
                      width: Get.width,
                      height: Get.width * Get.size.aspectRatio + 60,
                      child: DanmakuView(
                        key: UniqueKey(),
                        createdController: (controller) {
                          danmakuController = controller;
                        },
                        option: DanmakuOption(
                          fontSize: 16,
                        ),
                      )
                    ),
                  ),
                Positioned(
                  top: 0,
                  width: Get.width,
                  height: Get.width * Get.size.aspectRatio + 50,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isVideoControlAreaShowing =
                        !_isVideoControlAreaShowing;
                      });
                    },
                    child: _isVideoControlAreaShowing
                        ? _videoPlayerControlArea()
                        : Container(
                      color: Colors.transparent,
                    ),
                  ),
                )
              ],
            ),
          ),
          const Expanded(
              child: Stack(
                children: [
                  ChatArea(),
                  //TODO
                ],
              )
          ),
          const SizedBox(height: 8,),
          _bottomArea(),
          const SizedBox(height: 8,)
        ]));
  }

  Widget _videoArea(){
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: _videoPlayerController.value.aspectRatio,
            child: VideoPlayer(_videoPlayerController),
          );
        } else {
          return SizedBox(
            height: Get.width * Get.size.aspectRatio + 50,
            child: const Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget _bottomArea() {
    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextField(
            controller: _barrageEditingController,
            // cursorWidth: 1.5,
            style: const TextStyle(
              color: Color(0xff333333),
              fontSize: 14.0,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
              fillColor: Colors.grey[200],
              filled: true,
              border: const OutlineInputBorder(borderSide: BorderSide.none),
              hintText: '吐个槽呗~',
            ),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.send,
            color: Colors.cyan,
          ),
          onPressed: () {
            if (_barrageEditingController.text.isEmpty) return;
            _addDanmaku([
              DanmakuItem(
              _barrageEditingController.text,
            ),]);
            _barrageEditingController.clear();
          },
        )
      ],
    );
  }

  Widget _videoPlayerControlArea() {
    return Align(
      alignment: Alignment.topLeft,
      child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.8, 1],
              colors: [
                Color.fromRGBO(0, 0, 0, 0),
                Color.fromRGBO(0, 0, 0, 0.8),
              ],
            ).createShader(bounds);
          },
          blendMode: BlendMode.color,
          child: Container(
              decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(color: Color(0xffeeeeee), width: 0),
                    bottom: BorderSide(color: Colors.white, width: 0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      _videoPlayerController.value.isPlaying
                          ? IconButton(
                              icon: const Icon(
                                Icons.pause,
                                color: Colors.white,
                                size: 24.0,
                              ),
                              onPressed: () {
                                setState(() {
                                  _videoPlayerController.pause();
                                });
                              },
                            )
                          : IconButton(
                              icon: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 24.0,
                              ),
                              onPressed: () {
                                setState(() {
                                  _videoPlayerController.play();
                                });
                              },
                            ),

                      const Expanded(child: SizedBox()),

                      if (!_isDanmakuShowing)
                        GestureDetector(
                          child: SvgPicture.asset("assets/icon/barrage_off.svg",
                              width: 24, height: 24,
                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),),
                          onTap: () {
                            _bulletsStart();

                          },
                        ),

                      if (_isDanmakuShowing)
                        GestureDetector(
                          child: SvgPicture.asset("assets/icon/barrage_on.svg",
                              width: 24, height: 24,
                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),),
                          onTap: () {
                            _bulletsStop();
                          },
                        ),

                      const SizedBox(
                        width: 10,
                      ),
                        IconButton(
                          icon: const Icon(
                            Icons.fullscreen,
                            color: Colors.white,
                            size: 24.0,
                          ),
                          onPressed: () {
                            Get.to(() => LiveFullScreenPage(videoPlayerController: _videoPlayerController,));
                          },
                        ),

                      // if (_isFullScreen)
                      //   IconButton(
                      //     icon: const Icon(
                      //       Icons.fullscreen_exit,
                      //       color: Colors.white,
                      //       size: 24.0,
                      //     ),
                      //     onPressed: () {
                      //       setState(() {
                      //         _isFullScreen = false;
                      //       });
                      //     },
                      //   ),
                    ],
                  ),
                ],
              ))),
    );
  }

  Future<void> _fetchData() async {
    _bulletsStart();

    _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',));
    _initializeVideoPlayerFuture = _videoPlayerController.initialize();

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

  void _bulletsStart() {
    if(!_isDanmakuShowing){
      _isDanmakuShowing = true;
      List<DanmakuItem> bullets = List<DanmakuItem>.generate(10, (i) {
        return DanmakuItem(
          i.toString(),
        );
      });
      _addDanmaku(bullets);
      if(mounted){
        setState(() {});
      }
    }
  }

  void _bulletsStop() {
    if(_isDanmakuShowing){
      _isDanmakuShowing = false;
      danmakuController?.pause();
      if(mounted){
        setState(() {});
      }
    }
  }

  void _addDanmaku(List<DanmakuItem> items) {
    //todo:api
    if (!_isDanmakuShowing) {
      return;
    }
    danmakuController?.addItems(items);
  }
}
