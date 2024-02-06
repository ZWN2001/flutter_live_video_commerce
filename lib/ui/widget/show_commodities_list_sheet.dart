import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import '../../entity/commodity/commodity.dart';
import '../page/commodity/commodity_detail_page.dart';

class ShowCommoditiesListSheet {

  static Future showCommoditiesListSheet(
  BuildContext context,
  List<Commodity> commodities
  ) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
            children: [
              const SizedBox(height: 8,),
              Row(
                children: [
                  const SizedBox(width: 12,),
                  Text("${commodities[0].anchorName}的商品列表", textAlign: TextAlign.center,),
                  const Expanded(child: SizedBox.shrink(),),
                  InkWell(
                    child: const Column(
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.grey,
                          size: 18,
                        ),
                        Text("购物车",style: TextStyle(color: Colors.grey,fontSize: 12),),
                      ],
                    ),
                    onTap: () {
                      //TODO: go to cart
                    },
                  ),
                  const SizedBox(width: 16,),
                ],
              ),
              const Divider(),
              ...commodities.map((Commodity commodity) {
                return _commodityListTile(context, commodity);
              }).toList(),
            ]
        );
      },
    );
  }

  static Widget _commodityListTile(BuildContext context, Commodity commodity){
    return ListTile(
      leading: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(
            commodity.imageUrl[0],
            fit: BoxFit.fill,
          )
      ),
      title: Text(commodity.commodityName),
      subtitle: Text("单价：${commodity.price.toString()}"),
      trailing: Container(
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.add_shopping_cart,
              color: Colors.white,
              size: 24.0,
            ),
            onPressed: () {
              BotToast.showText(text: "添加购物车成功");
            },
          )
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return CommodityDetailPage(commodity: commodity,);
          },
        );
      },
    );
  }
}