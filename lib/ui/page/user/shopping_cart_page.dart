import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:live_video_commerce/api/api.dart';
import 'package:live_video_commerce/entity/result.dart';

import '../../../entity/commodity/commodity.dart';
import '../../widget/item_calculate_widget.dart';
import '../commodity/order_confirm_page.dart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  ShoppingCartPageState createState() => ShoppingCartPageState();
}

class ShoppingCartPageState extends State<ShoppingCartPage>{
  ///还是觉得这段代码可读性不太好，抽象成一个类，然后把数据和方法都放在类里面，可能看起来会更清晰
  List<Commodity> commodityList = [];///不要使用该数据作为UI数据源
  Map<String,List<Commodity>> anchorCommodityData = {};
  Map<String,bool> anchorCommoditySelectedAll = {};
  Map<String,List<bool>> commoditySelected = {};
  Map<String,List<int>> commodityCount = {};
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
                  Map<String,List<Commodity>> selectedAnchorCommodity = {};
                  Map<String,List<int>> selectedCommodityCount = {};
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

  Widget _cartItemCard(String anchorName, List<Commodity> list) {
    return Card(
      child: Column(
        children: [
          Row(
            children: [
              Radio(value: true,
                  groupValue: anchorCommoditySelectedAll[anchorName],
                  onChanged: (v){
                    anchorCommoditySelectedAll[anchorName] = v!;
                    setState(() {
                      commoditySelected[anchorName] = List.filled(list.length, v);
                      _countTotalPrice();
                      _countTotalCount();
                    });
                  }
              ),
              const SizedBox(width: 16,),
              Text(anchorName),
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
                        anchorCommodityData[anchorName]!.removeAt(index);
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
                child: _commodityItem(list[index],index),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _commodityItem(Commodity commodity,int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, right: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Checkbox(
              value: commoditySelected[commodity.anchorName]?[index],
              onChanged: (v){
            commoditySelected[commodity.anchorName]?[index] = v!;
            _countTotalPrice();
            _countTotalCount();
            //commoditySelected[commodity.anchorName]若全为true，则anchorCommoditySelectedAll[commodity.anchorName]为true
            anchorCommoditySelectedAll[commodity.anchorName] = commoditySelected[commodity.anchorName]!.every((element) => element);
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
                count: commodityCount[commodity.anchorName]![index],
                mainAxisAlignment: MainAxisAlignment.end,
                size: 26,
                onCountChanged: (int value) {
                  commodityCount[commodity.anchorName]![index] += value;
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
        String anchorName = key.anchorName;
        if(anchorCommodityData[anchorName] == null){
          anchorCommodityData[anchorName] = [];
        }
        anchorCommodityData[anchorName]?.add(key);

        anchorCommoditySelectedAll[anchorName] = false;
        if(commoditySelected[anchorName] == null){
          commoditySelected[anchorName] = List.empty(growable: true);
        }
        commoditySelected[anchorName]?.addAll(List.filled(anchorCommodityData[anchorName]?.length??0, false));

        if(commodityCount[anchorName] == null){
          commodityCount[anchorName] = List.empty(growable: true);
        }
        commodityCount[anchorName]?.add(value);
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
    List<String> keysToRemove = [];

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