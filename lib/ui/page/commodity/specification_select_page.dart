import 'package:flutter/material.dart';
import 'package:live_video_commerce/ui/widget/item_calculate_widget.dart';

import '../../../entity/commodity/commodity.dart';
import '../../../entity/commodity/commodity_specification.dart';

class SpecificationSelectPage extends StatefulWidget {
  final Commodity commodity;
  final Function(int) onCountChanged;
  final int? selectIndex;
  final int selectedCount;

  const SpecificationSelectPage({
    Key? key,
    required this.commodity, required this.onCountChanged, this.selectIndex, required this.selectedCount,
  }) : super(key: key);

  @override
  SpecificationSelectPageState createState() => SpecificationSelectPageState();
}

class SpecificationSelectPageState extends State<SpecificationSelectPage> {
  int? _selectIndex;

  late Commodity commodity;
  late List<CommoditySpecification> specifications;

  @override
  void initState() {
    super.initState();
    commodity = widget.commodity;
    specifications = commodity.specification;
    _selectIndex = widget.selectIndex;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _titleRow(),
        _specificationCard(),
        Center(
          child:SizedBox(width: 96,
              height: 42,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(_selectIndex);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    )
                ),
                child: const Text("确定",style: TextStyle(color: Colors.white),),
              ))
        )
      ],
    );
  }

  Widget _titleRow() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 12, 16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                commodity.imageUrl[0],
                width: 60,
                height: 60,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(width: 12,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("¥ ${commodity.price}",
                    style: const TextStyle(fontSize: 18, color: Colors.red),),
                  const SizedBox(height: 8,),
                  if(_selectIndex != null)
                    Text("已选：${specifications[_selectIndex!].specification}",
                      style: const TextStyle(
                          fontSize: 12, color: Colors.grey),),
                  if(_selectIndex == null)
                    const Text("请选择规格",
                      style: TextStyle(fontSize: 12, color: Colors.grey),),
                ],
              ),
            ),
            //关闭
            InkWell(
              child: const Icon(Icons.close),
              onTap: () {
                Navigator.of(context).pop(_selectIndex);
              },
            ),
          ],
        )
    );
  }

  Widget _specificationCard() {
    List<Widget> specificationSelectSheetItems = [];
    for (var i = 0; i < specifications.length; i++) {
      specificationSelectSheetItems.add(_buildSpecificationSelectSheetItem(
          context, specifications[i], const EdgeInsets.fromLTRB(8, 8, 8, 0), i));
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
      child: Card(
        color: Colors.grey[100],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8), child: Text("规格"),),
                ...specificationSelectSheetItems,
                const SizedBox(height: 24,),
                Row(
                  children: [
                    const SizedBox(width: 8,),
                    const Text("数量"),
                    const Expanded(child: SizedBox.shrink(),),
                    ItemCalculateWidget(
                        onCountChanged: widget.onCountChanged, count: widget.selectedCount)
                  ],
                )
              ],
            ),
          )
      ),
    );
  }

  Widget _buildSpecificationSelectSheetItem(BuildContext context,
      CommoditySpecification specification,
      EdgeInsetsGeometry padding,
      int index,) {
    return Padding(
        padding: padding,
        child: GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: index == _selectIndex ? Colors.blue[50] : Colors.grey[350],
              border: Border.all(
                  color: index == _selectIndex ? Colors.blue : Colors.grey[350]!,
                  width: 1),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    specification.imageUrl,
                    width: 42,
                    height: 42,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(width: 8,),
                Expanded(child: Text(specification.specification, maxLines: 2,
                  overflow: TextOverflow.ellipsis,style: TextStyle(
                      color: index == _selectIndex ? Colors.blue : Colors.black),),),
                const SizedBox(width: 8,),
                Text("¥${specification.price}",
                  style: const TextStyle(color: Colors.blue),),
                const SizedBox(width: 12,),
              ],
            ),
          ),
          onTap: () {
            setState(() {
              _selectIndex = index;
            });
          },
        ));
  }
}