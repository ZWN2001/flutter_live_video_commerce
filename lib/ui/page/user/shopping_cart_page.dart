import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:live_video_commerce/api/api.dart';
import 'package:live_video_commerce/entity/result.dart';

import '../../../entity/commodity/commodity.dart';
import '../../../entity/user.dart';
import '../../widget/item_calculate_widget.dart';
import '../order/order_confirm_page.dart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  ShoppingCartPageState createState() => ShoppingCartPageState();
}

class ShoppingCartPageState extends State<ShoppingCartPage>{
  ///还是觉得这段代码可读性不太好，抽象成一个类，然后把数据和方法都放在类里面，可能看起来会更清晰
  List<Commodity> commodityList = [];///不要使用该数据作为UI数据源
  Map<User,List<Commodity>> anchorCommodityData = {};
  Map<User,bool> anchorCommoditySelectedAll = {};
  Map<User,List<bool>> commoditySelected = {};
  Map<User,List<int>> commodityCount = {};
  double totalPrice = 0;
  int totalCount = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('购物车'),
      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator(),) : _buildBody(),
    );
  }

  Widget _buildBody(){
    return Column(
      children: [
        Expanded(child: ListView.builder(
          itemCount: anchorCommodityData.length,
          itemBuilder: (BuildContext context, int index) {
            if(anchorCommodityData.values.toList()[index].isNotEmpty){
              return _cartItemCard(anchorCommodityData.keys.toList()[index], anchorCommodityData.values.toList()[index]);
            }
            return Container();
          },
        )),
        Container(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //全选
              Checkbox(
                  value: anchorCommoditySelectedAll.values.every((element) => element),
                  onChanged: (v){
                    anchorCommoditySelectedAll.forEach((key, value) {
                      anchorCommoditySelectedAll[key] = v!;
                    });
                    setState(() {
                      commoditySelected.forEach((key, value) {
                        commoditySelected[key] = List.filled(value.length, v!);
                      });
                      _countTotalPrice();
                      _countTotalCount();
                    });
                  }),
              if(totalPrice<10000000)
                const Text(
                  '全选',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              Expanded(child: Container(),),
              if(totalPrice<10000000)
                Text(
                  '共$totalCount件',
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
                totalPrice.toStringAsFixed(2),
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
                onPressed: () {
                  Map<User,List<Commodity>> selectedAnchorCommodity = {};
                  Map<User,List<int>> selectedCommodityCount = {};
                  anchorCommodityData.forEach((key, value) {
                    List<Commodity> selectedCommodity = [];
                    List<int> selectedCount = [];
                    for(int i=0;i<value.length;i++){
                      if(commoditySelected[key]?[i]??false){
                        selectedCommodity.add(value[i]);
                        selectedCount.add(commodityCount[key]?[i]??0);
                      }
                    }
                    if(selectedCommodity.isNotEmpty){
                      selectedAnchorCommodity[key] = selectedCommodity;
                      selectedCommodityCount[key] = selectedCount;
                    }
                  });
                  Get.to(()=>OrderConfirmPage(
                    anchorCommodityData: selectedAnchorCommodity,
                    commodityCount: selectedCommodityCount,));
                },
                child: const Text('结算',style: TextStyle(color: Colors.white),),
              ),
              const SizedBox(width: 12,),
            ],
          ),
        ),
      ],
    );
  }

  Widget _cartItemCard(User user, List<Commodity> list) {
    return Card(
      child: Column(
        children: [
          Row(
            children: [
              Radio(value: true,
                  groupValue: anchorCommoditySelectedAll[user],
                  onChanged: (v){
                    anchorCommoditySelectedAll[user] = v!;
                    setState(() {
                      commoditySelected[user] = List.filled(list.length, v);
                      _countTotalPrice();
                      _countTotalCount();
                    });
                  }
              ),
              const SizedBox(width: 16,),
              Text("${user.nickname}的直播间"),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return Slidable(
                key: const ValueKey(0),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (c){
                        //删除
                        anchorCommodityData[user]!.removeAt(index);
                        _countTotalPrice();
                        _countTotalCount();
                        _onListChanged();
                        setState(() {});
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete_outline,
                      label: '删除',
                    ),
                  ],
                ),
                child: _commodityItem(user,list[index],index),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _commodityItem(User user,Commodity commodity,int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, right: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Checkbox(
              value: commoditySelected[user]?[index],
              onChanged: (v){
            commoditySelected[user]?[index] = v!;
            _countTotalPrice();
            _countTotalCount();
            //commoditySelected[commodity.anchorName]若全为true，则anchorCommoditySelectedAll[commodity.anchorName]为true
            anchorCommoditySelectedAll[user] = commoditySelected[user]!.every((element) => element);
            setState(() {});
          }
          ),
          const SizedBox(width: 16,),
          ClipRRect(
            borderRadius: BorderRadius.circular(24.0),
            child: SizedBox(
              width: 90,
              height: 90,
              child: Image.network(commodity.imageUrl[0]),
            ),
          ),
          const SizedBox(width: 16,),
          Expanded(child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(commodity.commodityName,
                    style: const TextStyle(fontSize: 16),),
                  Text(
                    commodity.specification[0].specification,
                    maxLines: 5,
                    style: const TextStyle(color: Colors.grey,
                        overflow: TextOverflow.ellipsis),),
                  const SizedBox(height: 6,),
                  Text('￥${commodity.price}',
                    style: const TextStyle(fontSize: 20, color: Colors.blue),),
                  const SizedBox(height: 6,),
                ],
              ),

              ItemCalculateWidget(
                count: commodityCount[user]![index],
                mainAxisAlignment: MainAxisAlignment.end,
                size: 26,
                onCountChanged: (int value) {
                  commodityCount[user]![index] += value;
                  _countTotalPrice();
                  _countTotalCount();
                  setState(() {});
                },
              ),
            ],
          ),)
        ],
      ),);
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    ResultEntity<Map<Commodity,int>> result = await CommodityAPI.getShoppingCart();

    if(result.success){
      Map<Commodity,int> commodityMap = result.data!;
      commodityMap.forEach((key, value){
        User user = User.empty();
        user.uid = key.anchorId;
        user.nickname = key.anchorName;
        if(anchorCommodityData[user] == null){
          anchorCommodityData[user] = [];
        }
        anchorCommodityData[user]?.add(key);

        anchorCommoditySelectedAll[user] = false;
        if(commoditySelected[user] == null){
          commoditySelected[user] = List.empty(growable: true);
        }
        commoditySelected[user]?.addAll(List.filled(anchorCommodityData[user]?.length??0, false));

        if(commodityCount[user] == null){
          commodityCount[user] = List.empty(growable: true);
        }
        commodityCount[user]?.add(value);
      });

      _countTotalPrice();
      _countTotalCount();
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _countTotalPrice(){
    totalPrice = 0;
    commoditySelected.forEach((key, value) {
      for (int i = 0; i < value.length; i++) {
        if(value[i]){
          double price = anchorCommodityData[key]?[i].price??0;
          int count = commodityCount[key]?[i]??0;
          totalPrice += price * count;
        }
      }
    });
  }

  void _countTotalCount(){
    totalCount = 0;
    commoditySelected.forEach((key, value) {
      for (int i = 0; i < value.length; i++) {
        if(value[i]){
          totalCount += commodityCount[key]?[i]??0;
        }
      }
    });
  }

  void _onListChanged(){
    List<User> keysToRemove = [];

    anchorCommodityData.forEach((key, value) {
      if (value.isEmpty) {
        keysToRemove.add(key);
      }
    });

    for (var key in keysToRemove) {
      anchorCommodityData.remove(key);
      commoditySelected.remove(key);
      commodityCount.remove(key);
      anchorCommoditySelectedAll.remove(key);
    }

  }

}