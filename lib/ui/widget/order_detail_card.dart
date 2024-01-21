import 'package:flutter/material.dart';

import '../../entity/order.dart';
import 'item_calculate_widget.dart';

///TODO：多个商品
class OrderDetailCard extends StatefulWidget {
  final Order order;
  const OrderDetailCard({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderDetailCard> createState() => _OrderDetailCardState();
}

class _OrderDetailCardState extends State<OrderDetailCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 4),
      child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
          child: Column(
            children: [
              ///订单主播
              Row(
                  children: [
                    const Icon(Icons.storefront, color: Colors.grey,),
                    const SizedBox(width: 8.0,),
                    Text(
                      widget.order.commodity[0].commodityName,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]
              ),
              const SizedBox(height: 8.0,),

              ///订单详情
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24.0),
                    child: SizedBox(
                      width: 90,
                      height: 90,
                      child: Image.network(widget.order.commodity[0].imageUrl[0]),
                    ),
                  ),
                  const SizedBox(width: 14.0,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.order.commodity[0].commodityName,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.order.commodity[0].specification[0].specification,
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8.0,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '￥${widget.order.commodity[0].price}',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'x${widget.order.quantity[0]}',
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ItemCalculateWidget(
                    count: widget.order.quantity[0],
                    onCountChanged: (int value) {
                      widget.order.quantity[0] += value;
                      setState(() {});
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16.0,),

              ///总价
              Row(
                children: [
                  const Text('商品总价'),
                  const Expanded(child: SizedBox.shrink()),
                  Text(
                    '￥${widget.order.commodity[0].price * widget.order.quantity[0]}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0,),

              //运费
              Row(
                children: [
                  const Text('运费'),
                  const Expanded(child: SizedBox.shrink()),
                  Text(
                    '￥${widget.order.commodity[0].freight}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0,),

              ///需付款
              Row(
                children: [
                  const Text('需付款'),
                  const Expanded(child: SizedBox.shrink()),
                  Text(
                    '￥${widget.order.totalPrice + widget.order.commodity[0].freight}',
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),


            ],
          )
      ),
    );
  }
}