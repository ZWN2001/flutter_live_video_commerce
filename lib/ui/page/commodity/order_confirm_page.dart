import 'package:flutter/material.dart';
import 'package:live_video_commerce/utils/constant_string_utils.dart';

import '../../../entity/order.dart';

class OrderConfirmPage extends StatefulWidget {
  final Order order;
  const OrderConfirmPage({super.key, required this.order});

  @override
  OrderConfirmPageState createState() => OrderConfirmPageState();
}

class OrderConfirmPageState extends State<OrderConfirmPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ConstantStringUtils.orderStatus[widget.order.status]!),
        centerTitle: true,
      ),
      body: Container(),
    );
  }
}