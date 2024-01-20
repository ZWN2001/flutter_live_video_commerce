import 'package:flutter/material.dart';
import 'package:live_video_commerce/utils/constant_string_utils.dart';

import '../../../entity/order.dart';
import '../../../entity/receiving_info.dart';
import '../../widget/order_detail_card.dart';
import '../../widget/receiving_info_card.dart';

class OrderConfirmPage extends StatefulWidget {
  final Order order;
  const OrderConfirmPage({super.key, required this.order});

  @override
  OrderConfirmPageState createState() => OrderConfirmPageState();
}

class OrderConfirmPageState extends State<OrderConfirmPage> {
  ReceivingInfo receivingInfo = ReceivingInfo(
    name: '张三',
    phone: '12345678901',
    address: '山东省 济南市 历城区 港沟街道 舜华路1500号山东大学软件园校区教学楼',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ConstantStringUtils.orderStatus[widget.order.status]!),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: ListView(
            children: [
              ReceivingInfoCard(receivingInfo: receivingInfo,),
              const SizedBox(height: 12,),
              OrderDetailCard(order: widget.order,),
            ],
          )),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '共${widget.order.commodity.length}件商品',
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
                  '${widget.order.totalPrice}',
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