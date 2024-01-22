import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../entity/commodity.dart';
import '../../../entity/commodity_specification.dart';
import '../../widget/item_calculate_widget.dart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  ShoppingCartPageState createState() => ShoppingCartPageState();
}

class ShoppingCartPageState extends State<ShoppingCartPage>{
  List<Commodity> commodityList = [];///不要使用该数据作为UI数据源
  Map<String,List<Commodity>> anchorCommodityData = {};
  Map<String,bool> anchorCommoditySelectedAll = {};
  Map<String,List<bool>> commoditySelected = {};
  Map<String,List<int>> commodityCount = {};
  double totalPrice = 0;
  int totalCount = 0;

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
      body: Column(
        children: [
          Expanded(child: ListView.builder(
            itemCount: anchorCommodityData.length,
            itemBuilder: (BuildContext context, int index) {
              return _cartItemCard(anchorCommodityData.keys.toList()[index], anchorCommodityData.values.toList()[index]);
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
                  onPressed: () {},
                  child: const Text('结算',style: TextStyle(color: Colors.white),),
                ),
                const SizedBox(width: 12,),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cartItemCard(String anchorName, List<Commodity> list) {
    return Card(
      child: Column(
        children: [
          Row(
            children: [
              Checkbox(
                  value: anchorCommoditySelectedAll[anchorName],
                  onChanged: (v){
                anchorCommoditySelectedAll[anchorName] = v!;
                setState(() {
                  commoditySelected[anchorName] = List.filled(list.length, v);
                  _countTotalPrice();
                  _countTotalCount();
                });
              }),
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
                      flex: 2,
                      onPressed: (c){//TODO
                         },
                      backgroundColor: const Color(0xFF7BC043),
                      foregroundColor: Colors.white,
                      icon: Icons.archive,
                      label: 'Archive',
                    ),
                    SlidableAction(
                      onPressed: (c){},
                      backgroundColor: const Color(0xFF0392CF),
                      foregroundColor: Colors.white,
                      icon: Icons.save,
                      label: 'Save',
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
    CommoditySpecification commoditySpecification = CommoditySpecification(
      cid: "1",
      id: "1",
      imageUrl: "https://www.zwn2001.space/img/favicon.webp",
      specification: "Sample Specification",
    );

    Commodity commodity = Commodity(
      cid: "1",
      commodityName: "Test Commodity",
      anchorId: "123",
      anchorName: "Test Anchor",
      price: 99.99,
      freight: 5.0,
      specification: [commoditySpecification],
      imageUrl: ["https://www.zwn2001.space/img/favicon.webp"],
    );

    commodityList = [commodity,commodity];
    commodity = Commodity(
      cid: "2",
      commodityName: "Test Commodity2",
      anchorId: "123",
      anchorName: "Test Anchor2",
      price: 999000,
      freight: 5.0,
      specification: [commoditySpecification],
      imageUrl: ["https://www.zwn2001.space/img/favicon.webp"],
    );
    commodityList.add(commodity);
    for (var element in commodityList) {
      if(anchorCommodityData[element.anchorName] == null){
        anchorCommodityData[element.anchorName] = [];
      }
      anchorCommodityData[element.anchorName]?.add(element);
    }

    for (var element in anchorCommodityData.keys) {
      anchorCommoditySelectedAll[element] = false;
      commoditySelected[element] = List.filled(anchorCommodityData[element]?.length??0, false);
      commodityCount[element] = List.filled(anchorCommodityData[element]?.length??0, 1);
    }

    _countTotalPrice();
    _countTotalCount();
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

}