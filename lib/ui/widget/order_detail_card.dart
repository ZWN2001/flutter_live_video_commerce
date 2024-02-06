import 'package:flutter/material.dart';
import 'package:live_video_commerce/entity/commodity/commodity.dart';
import 'package:live_video_commerce/entity/order/order_commodity_detailed_info.dart';

import 'item_calculate_widget.dart';

class OrderDetailCard extends StatefulWidget {
  final List<OrderCommodityDetailedInfo> orderList;
  final Function(int countChanged, double priceChanged) onCountChange;
  const OrderDetailCard({Key? key, required this.orderList, required this.onCountChange}) : super(key: key);

  @override
  State<OrderDetailCard> createState() => _OrderDetailCardState();
}

class _OrderDetailCardState extends State<OrderDetailCard> {
  int totalCount = 0;
  double totalPrice = 0;
  final List<Widget> _orderedCommodityItemList = [];

  @override
  void initState() {
    super.initState();
    totalCount = widget.orderList.fold(0, (previousValue, element) => previousValue + element.quantity);
    totalPrice = widget.orderList.fold(0, (previousValue, element) => previousValue + element.totalPrice);
    for(int i = 0; i < widget.orderList.length; i++){
      _orderedCommodityItemList.add(_orderedCommodityItem(widget.orderList[i].commodity,i));
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
                      widget.orderList[0].commodity.commodityName,
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
                    '￥${totalPrice.toStringAsFixed(2)}',
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
                    '￥${widget.orderList[0].commodity.freight}',
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
                    '￥${(totalPrice + widget.orderList[0].commodity.freight).toStringAsFixed(2)}',
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
                  'x${widget.orderList[index].quantity}',
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
              count: widget.orderList[index].quantity,
              onCountChanged: (int value) {
                widget.orderList[index].quantity += value;
                widget.orderList[index].totalPrice += value * commodity.price;
                totalPrice += value * commodity.price;
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