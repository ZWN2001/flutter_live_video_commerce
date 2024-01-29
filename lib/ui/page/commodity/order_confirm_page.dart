import 'package:flutter/material.dart';
import 'package:live_video_commerce/entity/order/order_commodity_detailed_info.dart';
import 'package:live_video_commerce/utils/constant_string_utils.dart';

import '../../../entity/commodity.dart';
import '../../../entity/receiving_info.dart';
import '../../widget/order_detail_card.dart';
import '../../widget/receiving_info_card.dart';

class OrderConfirmPage extends StatefulWidget {
  final Map<String,List<Commodity>> anchorCommodityData;
  final Map<String,List<int>> commodityCount;
  const OrderConfirmPage({
    super.key,
    required this.anchorCommodityData,
    required this.commodityCount
  });

  @override
  OrderConfirmPageState createState() => OrderConfirmPageState();
}

//TODO:检查迁移带来的逻辑问题
class OrderConfirmPageState extends State<OrderConfirmPage> {
  ReceivingInfo receivingInfo = ReceivingInfo(
    id: '0',
    name: '张三',
    phone: '12345678901',
    locateArea: '山东省 济南市 历城区 港沟街道 ',
    detailedAddress: '舜华路1500号山东大学软件园校区教学楼',
  );
  List<OrderCommodityDetailedInfo> orderCommodityDetailedInfoList = [];
  int totalCount = 0;
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    widget.anchorCommodityData.forEach((key, value) {
      //orderPrice为value中所有商品的单价乘以数量的和
      double orderPrice = 0;
      for(int i = 0; i < value.length; i++){
        orderPrice += value[i].price * widget.commodityCount[key]![i];
      }

      OrderCommodityDetailedInfo orderCommodityDetailedInfo = OrderCommodityDetailedInfo(
        oid: '1',
        commodity: value[0],
        receivingInfo: receivingInfo,
        totalPrice: orderPrice,
        quantity: 1
      );

      orderCommodityDetailedInfoList.add(orderCommodityDetailedInfo);

      //commodityCount[key]求和加到totalCount
      totalCount += widget.commodityCount[key]!.reduce((value, element) => value + element);
      totalPrice += orderPrice;
    });
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
              ReceivingInfoCard(receivingInfo: receivingInfo,),
              const SizedBox(height: 12,),
              OrderDetailCard(
                orderList: orderCommodityDetailedInfoList,
                onCountChange: (int totalCount, double totalPrice) {
                  setState(() {
                    this.totalCount += totalCount;
                    this.totalPrice += totalPrice;
                  });
                },
              )
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
                  onPressed: () {},
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
}