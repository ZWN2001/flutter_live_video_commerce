import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:get/get.dart';
import 'package:live_video_commerce/ui/page/commodity/specification_select_page.dart';
import 'package:live_video_commerce/ui/page/user/shopping_cart_page.dart';

import '../../../entity/commodity.dart';
import 'order_confirm_page.dart';

class CommodityDetailPage extends StatefulWidget {
  final Commodity commodity;

  const CommodityDetailPage({Key? key, required this.commodity})
      : super(key: key);

  @override
  CommodityDetailPageState createState() => CommodityDetailPageState();
}

class CommodityDetailPageState extends State<CommodityDetailPage> {
  int? _selectIndex;
  int _selectedCount = 1;
  late Commodity _commodity;

  @override
  void initState() {
    super.initState();
    _commodity = widget.commodity;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              SizedBox(
                width: Get.width,
                height: Get.width,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      child: Swiper(
                        itemBuilder: (context, index) {
                          return Image.network(
                            _commodity.imageUrl[index],
                            fit: BoxFit.fitWidth,
                          );
                        },
                        autoplay: true,
                        itemCount: _commodity.imageUrl.length,
                        pagination: const SwiperPagination(
                            builder: SwiperPagination.rect),
                        control: const SwiperControl(),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 16,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 8,
                  ),
                  const Text(
                    "￥",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.cyan,
                    ),
                  ),
                  Text(
                    _commodity.price.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 8),
                child: Text(
                  _commodity.commodityName,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                  child: Card(
                    child: Column(
                      children: [
                        ListTile(
                            leading: const Text(
                              "运费",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            title: Text(
                              "${_commodity.freight}元",
                              style: const TextStyle(fontSize: 14),
                            )),
                        ListTile(
                          leading: const Text(
                            "规格",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          title: _selectIndex == null
                              ? Text(
                                  "共${_commodity.specification.length}种规格可选",
                                  style: const TextStyle(fontSize: 14),
                                )
                              : Text(
                                  "已选规格：${_commodity.specification[_selectIndex!].specification}    $_selectedCount件",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14),
                                ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () {
                            _selectSpecification();
                          },
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              const SizedBox(
                width: 16,
              ),
              InkWell(
                child: const Column(
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                    ),
                    Text("购物车"),
                  ],
                ),
                onTap: () {
                  Get.to(() => const ShoppingCartPage());
                },
              ),
              const Expanded(
                child: SizedBox.shrink(),
              ),
              InkWell(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      bottomLeft: Radius.circular(6)),
                  child: Container(
                    width: 120,
                    height: 48,
                    color: Colors.pink[50],
                    child: const Center(
                      child: Text(
                        '加入购物车',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(6),
                      bottomRight: Radius.circular(6)),
                  child: Container(
                      width: 120,
                      height: 48,
                      color: Colors.red,
                      child: const Center(
                          child: Text(
                        '立即购买',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ))),
                ),
                onTap: () {
                  if (_selectIndex != null) {
                    Commodity commodity = widget.commodity.clone();
                    commodity.specification = [
                      commodity.specification[_selectIndex!]
                    ];
                    Map<String, List<Commodity>> anchorCommodityData = {
                      commodity.anchorName: [commodity],
                    };
                    Map<String, List<int>> commodityCount = {
                      commodity.anchorName: [_selectedCount],
                    };
                    Get.to(() => OrderConfirmPage(
                          anchorCommodityData: anchorCommodityData,
                          commodityCount: commodityCount,
                        ));
                  } else {
                    _selectSpecification();
                  }
                },
              ),
              const SizedBox(
                width: 12,
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<void> _selectSpecification() async {
    int? index =
        await showModalBottomSheet<int>(context: context, builder: (context) {
      return SpecificationSelectPage(
        commodity: _commodity,
        selectIndex: _selectIndex,
        selectedCount: _selectedCount,
        onCountChanged: (count) {
          _selectedCount += count;
          setState(() {});
        },
      );
        });
    if (index != null) {
      // widget.commodity.specification = [widget.commodity.specification[index]];
      _selectIndex = index;
      setState(() {});
    }
  }
}
