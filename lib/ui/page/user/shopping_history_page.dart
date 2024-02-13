import 'package:flutter/material.dart';
import 'package:live_video_commerce/entity/order/order.dart';

import '../../../entity/commodity/commodity.dart';
import '../../../entity/commodity/commodity_specification.dart';
import '../../../entity/commodity/receiving_info.dart';
import '../../widget/my_order_card.dart';


class ShoppingHistoryPage extends StatefulWidget {
  const ShoppingHistoryPage({super.key});

  @override
  State<ShoppingHistoryPage> createState() => _ShoppingHistoryPageState();
}

class _ShoppingHistoryPageState extends State<ShoppingHistoryPage> {
  List<OrderMini> orderList = [];

  @override
  void initState() {
    super.initState();
    CommoditySpecification commoditySpecification = CommoditySpecification(
      cid: 1,
      id: 1,
      imageUrl: "https://www.zwn2001.space/img/favicon.webp",
      specification: "Sample Specification",
      price: 20
    );

    Commodity commodity = Commodity(
      cid: 1,
      commodityName: "Test Commodity",
      anchorId: "123",
      anchorName: "Test Anchor",
      price: 99.99,
      freight: 5.0,
      specification: [commoditySpecification],
      imageUrl: ["https://www.zwn2001.space/img/favicon.webp"],
    );

    ReceivingInfo receivingInfo = ReceivingInfo(
      id: 1,
      name: "John Doe",
      phone: "1234567890",
      locateArea: "City, State",
      detailedAddress: "123 Main St, City, State",
    );

    OrderMini order = OrderMini(
      oid: "1",
      commodity: commodity,
      totalPrice: 104.99,
      quantity: 1,
      orderStatus: 0,
    );

    orderList = [order,order,order,order,order,order,order,order,order,order,order,order,order];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("全部订单"),
      ),
      body: Container(
        color: Colors.grey[200],
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: orderList.length,
          itemBuilder: (BuildContext context, int index) {
            return MyOrderCard(order: orderList[index],);
          },
        ),
      ),
    );
  }
}