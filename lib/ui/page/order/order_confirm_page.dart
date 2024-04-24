import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:live_video_commerce/entity/order/order_commodity_detailed_info.dart';
import 'package:live_video_commerce/entity/user.dart';
import 'package:live_video_commerce/state/user_status.dart';
import 'package:live_video_commerce/utils/constant_string_utils.dart';

import '../../../api/api.dart';
import '../../../entity/commodity/commodity.dart';
import '../../../entity/commodity/receiving_info.dart';
import '../../../entity/order/order.dart';
import '../../../entity/order/order_commodity_info.dart';
import '../../../entity/result.dart';
import '../../widget/order_detail_card.dart';
import '../../widget/receiving_info_card.dart';
import '../user/edit_receiving_info_page.dart';

class OrderConfirmPage extends StatefulWidget {
  final Map<User,List<Commodity>> anchorCommodityData;
  final Map<User,List<int>> commodityCount;
  const OrderConfirmPage({
    super.key,
    required this.anchorCommodityData,
    required this.commodityCount
  });

  @override
  OrderConfirmPageState createState() => OrderConfirmPageState();
}

class OrderConfirmPageState extends State<OrderConfirmPage> {
  ReceivingInfo? receivingInfo;
  List<List<OrderCommodityDetailedInfo>> orderCommodityDetailedInfoList = [];
  int totalCount = 0;
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ConstantStringUtils.orderStatus[0]!),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: ListView(
            children: [
              receivingInfo!=null?
              ReceivingInfoCard(receivingInfo: receivingInfo!,)
              :
              ElevatedButton(onPressed: (){
                Get.to(EditReceivingInfoPage(isDefaultReceivingInfo: false, onEditSuccess: () {
                  setState(() {});
                },));
              }, child: const Text("请先添加收货信息")),
              const SizedBox(height: 12,),
              ...orderCommodityDetailedInfoList.map((e) => OrderDetailCard(
                orderList: e,
                onCountChange: (int totalCount, double totalPrice) {
                  setState(() {
                    this.totalCount += totalCount;
                    this.totalPrice += totalPrice;
                  });
                },
              )).toList(),
            ],
          )),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '共$totalCount件商品',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 4,),
                const Text('合计:',),
                const Text(
                  '￥',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 14,
                  ),
                ),
                Text(
                  totalPrice.toStringAsFixed(2),
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(width: 12,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: () {
                    if(receivingInfo != null){
                      createOrders();
                    }else{
                      BotToast.showText(text: "请先添加收货信息");
                    }
                  },
                  child: const Text('确认订单',style: TextStyle(color: Colors.white),),
                ),
                const SizedBox(width: 12,),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchData() async {
    ResultEntity<List<ReceivingInfo>> result = await ReceivingInfoAPI.getReceivingInfos();
    if(result.success&& result.data!= null && result.data!.isNotEmpty){
      receivingInfo = result.data![0];
    }
    print(widget.anchorCommodityData.toString());
    widget.anchorCommodityData.forEach((key, value) {
      //orderPrice为value中所有商品的单价乘以数量的和
      double orderPrice = 0;
      for(int i = 0; i < value.length; i++){
        orderPrice += value[i].price * widget.commodityCount[key]![i];
      }

      ///购买的单个主播的商品单
      List<OrderCommodityDetailedInfo> anchorCommodityList = [];
      for(int i = 0; i < value.length; i++){
        OrderCommodityDetailedInfo orderCommodityDetailedInfo = OrderCommodityDetailedInfo(
          oid: '1',
          commodity: value[i],
          receivingInfo: receivingInfo??ReceivingInfo.empty(),
          totalPrice: value[i].price * widget.commodityCount[key]![i],
          quantity: widget.commodityCount[key]![i],
        );
        anchorCommodityList.add(orderCommodityDetailedInfo);
      }
      orderCommodityDetailedInfoList.add(anchorCommodityList);

      //commodityCount[key]求和加到totalCount
      totalCount += widget.commodityCount[key]!.reduce((value, element) => value + element);
      totalPrice += orderPrice;
    });
    if(mounted) {
      setState(() {});
    }
  }

  Future<void> createOrders() async {
    for (var e1 in orderCommodityDetailedInfoList) {
      for (var e2 in e1) {
        e2.receivingInfo = receivingInfo!;
      }
    }
    for (var list in orderCommodityDetailedInfoList) {
      List<OrderCommodityInfo> orderCommodityInfo = [];
      for (var orderCommodityDetailedInfo in list) {
        orderCommodityInfo.add(OrderCommodityInfo(
          oid: '1',
          uid: UserStatus.user!.uid,
          commodityId: orderCommodityDetailedInfo.commodity.cid,
          receivingInfoId: receivingInfo!.id,
          specificationId: orderCommodityDetailedInfo.commodity.specification[0].id,
          quantity: orderCommodityDetailedInfo.quantity,
          totalPrice: orderCommodityDetailedInfo.totalPrice,
        ));
      }
      await CommodityAPI.orderCreate(orderCommodityInfo);
    }
  }
}