

import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:get/get.dart';

import '../../../entity/commodity.dart';
import '../../../entity/order.dart';
import 'order_confirm_page.dart';

class CommodityDetailPage extends StatefulWidget {
  final Commodity commodity;

  const CommodityDetailPage({Key? key, required this.commodity}) : super(key: key);

  @override
  CommodityDetailPageState createState() => CommodityDetailPageState();
}

class CommodityDetailPageState extends State<CommodityDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              SizedBox(
                width: Get.width,
                height: Get.width,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)
                      ),
                      child: Swiper(
                        itemBuilder: (context, index) {
                          return Image.network(
                            widget.commodity.imageUrl[index],
                            fit: BoxFit.fitWidth,
                          );
                        },
                        autoplay: true,
                        itemCount: widget.commodity.imageUrl.length,
                        pagination:
                        const SwiperPagination(builder: SwiperPagination.rect),
                        control: const SwiperControl(),
                      ),
                    ),
                    Positioned(
                      top: 8, right: 16,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),),
                  ],
                ),
              ),
              const SizedBox(height: 8,),
              Row(
                children: [
                  const SizedBox(width: 8,),
                  const Text("￥", style: TextStyle(
                    fontSize: 14,
                    color: Colors.cyan,
                  ),),
                  Text(
                    widget.commodity.price.toString(), style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyan,
                  ),),
                ],
              ),
              const SizedBox(height: 8,),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 8),
                child: Text(
                  widget.commodity.commodityName,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),),
              ),
              const SizedBox(height: 8,),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8,bottom: 8),
                child: Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Text("运费",style: TextStyle(color: Colors.grey,fontSize: 14),),
                        title: Text("${widget.commodity.freight}元",style: const TextStyle(fontSize: 14),)
                      ),
                      ListTile(
                          leading: const Text("规格",style: TextStyle(color: Colors.grey,fontSize: 14),),
                          title: Text("共${widget.commodity.specification.length}种规格可选",style: const TextStyle(fontSize: 14),),
                        trailing: const Icon(Icons.arrow_forward_ios,size: 16,),
                      ),
                    ],
                  ),
                )
              ),
            ],
          ),),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
          children: [
            const SizedBox(width: 16,),
            InkWell(
              child: const Column(
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                  ),
                  Text("购物车"),
                ],
              ),
              onTap: () {
                //TODO: go to cart
              },
            ),
            const Expanded(child: SizedBox.shrink(),),
            InkWell(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    bottomLeft: Radius.circular(6)
                ),
                child: Container(
                  width: 120,
                  height: 48,
                  color: Colors.pink[50],
                  child: const Center(
                    child: Text('加入购物车', style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                    ),
                  ),
                ),),
            ),
            InkWell(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(6),
                    bottomRight: Radius.circular(6)
                ),
                child: Container(
                    width: 120,
                    height: 48,
                    color: Colors.red,
                    child: const Center(
                        child: Text('立即购买', style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),))
                ),),
              onTap: (){
                Order order = Order(
                  oid: "1",
                  commodity: [widget.commodity],
                  receivingInfo: null,
                  status: 0,
                  createdAt: "2022-01-01 10:00:00",
                  payAt: "2022-01-01 10:00:00",
                  shipAt: "",
                  completeAt: "",
                  totalPrice: 104.99,
                  quantity: [1],
                );
                Get.to(()=>OrderConfirmPage(order: order,));
              },
            ),
            const SizedBox(width: 12,),
          ],
        ),)
      ],
    );
  }
}