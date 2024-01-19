import 'package:flutter/material.dart';
import 'package:live_video_commerce/entity/order.dart';

class MyOrderCard extends StatelessWidget {
  final Order order;
  const MyOrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          _titleRow(),
          _commodityRow(),
          _bottomRow(),
        ],
      ),
    );
  }

  Widget _titleRow(){
    return Row(
      children: [
        Expanded(
          child: Text(
            order.commodity[0].commodityName,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          order.status,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _commodityRow(){
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24.0),
          child: SizedBox(
            width: 90,
            height: 90,
            child: Image.network(order.commodity[0].imageUrl[0]),
          ),
        ),

        const SizedBox(width: 8.0,),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.commodity[0].commodityName,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                order.commodity[0].specification,
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
              '￥${order.commodity[0].price}',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'x${order.quantity}',
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _bottomRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '实付：￥${order.totalPrice}',
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}