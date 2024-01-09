import 'package:flutter/material.dart';
import 'package:live_video_commerce/entity/order.dart';

import '../../widget/my_order_card.dart';


class ShoppingHistoryPage extends StatelessWidget {
  final List<Order> orderList;
  const ShoppingHistoryPage({super.key, required this.orderList});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: orderList.length,
        itemBuilder: (BuildContext context, int index) {
          return MyOrderCard(order: orderList[index],);
        },
      ),
    );
  }
}