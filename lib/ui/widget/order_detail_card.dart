import 'package:flutter/material.dart';
import 'package:live_video_commerce/entity/commodity.dart';

import '../../entity/order.dart';
import 'item_calculate_widget.dart';

class OrderDetailCard extends StatefulWidget {
  final Order order;
  final Function(int countChanged, double priceChanged) onCountChange;
  const OrderDetailCard({Key? key, required this.order, required this.onCountChange}) : super(key: key);

  @override
  State<OrderDetailCard> createState() => _OrderDetailCardState();
}

class _OrderDetailCardState extends State<OrderDetailCard> {
  int totalCount = 0;
  final List<Widget> _orderedCommodityItemList = [];

  @override
  void initState() {
    super.initState();
    totalCount = widget.order.quantity.fold(0, (previousValue, element) => previousValue + element);
    for(int i = 0; i < widget.order.commodity.length; i++){
      _orderedCommodityItemList.add(_orderedCommodityItem(widget.order.commodity[i],i));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
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
              ..._orderedCommodityItemList,

              ///总价
              Row(
                children: [
                  const Text('商品总价'),
                  const Expanded(child: SizedBox.shrink()),
                  Text(
                    '￥${widget.order.totalPrice.toStringAsFixed(2)}',
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
                    '￥${(widget.order.totalPrice + widget.order.commodity[0].freight).toStringAsFixed(2)}',
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

  Widget _orderedCommodityItem(Commodity commodity,int index){
    return Column(
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24.0),
              child: SizedBox(
                width: 90,
                height: 90,
                child: Image.network(commodity.imageUrl[0]),
              ),
            ),
            const SizedBox(width: 14.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    commodity.commodityName,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    commodity.specification[0].specification,
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
                  '￥${commodity.price}',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'x${widget.order.quantity[index]}',
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
              count: widget.order.quantity[index],
              onCountChanged: (int value) {
                widget.order.quantity[index] += value;
                widget.order.totalPrice += value * commodity.price;
                //回调改变件数与总价
                widget.onCountChange(value, value * commodity.price);
                setState(() {});
              },
            ),
          ],
        ),
        const SizedBox(height: 16.0,),
      ],
    );
  }
}