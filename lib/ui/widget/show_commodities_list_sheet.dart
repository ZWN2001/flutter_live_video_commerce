import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_commerce/api/api.dart';
import 'package:live_video_commerce/entity/commodity/shopping_cart_item.dart';
import 'package:live_video_commerce/route/route.dart';
import 'package:live_video_commerce/state/user_status.dart';

import '../../entity/commodity/commodity.dart';
import '../../entity/result.dart';
import '../page/commodity/commodity_detail_page.dart';
import '../page/commodity/specification_select_page.dart';

class ShowCommoditiesListSheet {

  static int? index;

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
                  const Text("商品列表", textAlign: TextAlign.center,),
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
                      Get.toNamed(RouteTable.shoppingCart);
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
          child:  IconButton(
            icon: const Icon(
              Icons.add_shopping_cart,
              color: Colors.white,
              size: 24.0,
            ),
            onPressed: (){
              _addCart(context, commodity);
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

  static Future<void> _addCart(BuildContext context, Commodity commodity) async {
    if(UserStatus.isLogin){

      if(commodity.specification.length > 1 && index == null){
        int selectedCount = 1;
        index =
        await showModalBottomSheet<int>(context: context, builder: (context) {
          return StatefulBuilder(builder: (context,setState){
            return SpecificationSelectPage(
              commodity: commodity,
              selectedCount: selectedCount,
              onCountChanged: (count) {
                selectedCount += count;
                setState(() {});
              },
            );
          });
        });
        if(index != null){
          ShoppingCartItem item = ShoppingCartItem(
              uid: UserStatus.user!.uid,
              cid: commodity.cid,
              sid: commodity.specification[index!].id,
              counts: selectedCount,
              addTime: ''
          );
          ResultEntity result = await CommodityAPI.shoppingCartAdd(item);
          if(result.success){
            BotToast.showText(text: "添加购物车成功");
            index = null;
          }else{
            BotToast.showText(text: result.data);
          }
        }
      }else if(commodity.specification.length == 1 || index != null){
        ShoppingCartItem item = ShoppingCartItem(
            uid: UserStatus.user!.uid,
            cid: commodity.cid,
            sid: commodity.specification[0].id,
            counts: 1,
            addTime: ''
        );
        ResultEntity result = await CommodityAPI.shoppingCartAdd(item);
        if(result.success){
          BotToast.showText(text: "添加购物车成功");
        }else{
          BotToast.showText(text: result.data);
        }
      }
    }else{
      Get.toNamed(RouteTable.login);
    }
  }
}