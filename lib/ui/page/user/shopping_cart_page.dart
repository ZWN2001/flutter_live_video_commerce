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
  List<Commodity> commodityList = [];
  Map<String,List<Commodity>> anchorCommodityMap = {};
  List<bool> commoditySelected = [];
  List<int> commodityCount = [];

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
      body: ListView.builder(
        itemCount: anchorCommodityMap.length,
        itemBuilder: (BuildContext context, int index) {
          return _cartItemCard(anchorCommodityMap.keys.toList()[index], anchorCommodityMap.values.toList()[index]);
        },
      ),
    );
  }

  Widget _cartItemCard(String anchorName, List<Commodity> commodityList) {
    return Card(
      child: Column(
        children: [
          Row(
            children: [
              Radio(
                value: true,
                onChanged: (value) {}, groupValue: true,
              ),
              const SizedBox(width: 16,),
              Text(anchorName),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: commodityList.length,
            itemBuilder: (BuildContext context, int index) {
              return Slidable(
                key: const ValueKey(0),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      flex: 2,
                      onPressed: (c){},
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
                child: _commodityItem(commodityList[index],index),
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
          Radio(
            value: true,
            onChanged: (value) {
              commoditySelected[index] = value!;
              //TODO:选择商品
            },
            groupValue: commoditySelected[index],
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(commodity.commodityName,
                        style: const TextStyle(fontSize: 16),),
                      Text(
                        commodity.specification[0].specification,
                        maxLines: 5,
                        style: const TextStyle(color: Colors.grey,
                            overflow: TextOverflow.ellipsis),),
                    ],
                  ),
                  Text('￥${commodity.price}',
                    style: const TextStyle(fontSize: 20, color: Colors.blue),),
                ],
              ),
              const SizedBox(height: 6,),
              ItemCalculateWidget(
                count: commodityCount[index],
                mainAxisAlignment: MainAxisAlignment.end,
                size: 26,
                onCountChanged: (int value) {
                  commodityCount[index] += value;
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
      price: 99.99,
      freight: 5.0,
      specification: [commoditySpecification],
      imageUrl: ["https://www.zwn2001.space/img/favicon.webp"],
    );
    commodityList.add(commodity);
    for (var element in commodityList) {
      if(anchorCommodityMap[element.anchorName] == null){
        anchorCommodityMap[element.anchorName] = [];
      }
      anchorCommodityMap[element.anchorName]?.add(element);
      //commoditySelected置为未选择
      commoditySelected.add(false);
      commodityCount.add(1);
    }
  }

}