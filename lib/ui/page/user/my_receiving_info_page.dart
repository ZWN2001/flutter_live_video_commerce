import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../entity/receiving_info.dart';

class MyReceivingInfoPage extends StatefulWidget {
  const MyReceivingInfoPage({super.key});

  @override
  MyReceivingInfoPageState createState() => MyReceivingInfoPageState();
}

class MyReceivingInfoPageState extends State<MyReceivingInfoPage> {
  List<ReceivingInfo> _receivingInfoList = [];
  String _defaultReceivingInfoId = '1';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的收货信息'),
      ),
      body: Column(
        children: [
            Card(
               child: Column(
                 children: [
                   ..._receivingInfoList.map((e) => _receivingInfoItem(e, const EdgeInsets.fromLTRB(12, 4, 4, 4))).toList(),
                 ],
               )
           ),
          Expanded(child: Container(),),
          SizedBox(height: 72,child: Container(
            color: Colors.blue[100],
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const SizedBox(width: 24,),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {

                      },
                      child: const Text('+  新增收货信息'),
                    ),
                  ),
                  const SizedBox(width: 24,),
                ],
              ),
            )
          ),)
        ],
      ),
    );
  }

  Widget _receivingInfoItem(ReceivingInfo receivingInfo, EdgeInsets padding) {
    return Slidable(
      key: UniqueKey(),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (c){
              _defaultReceivingInfoId = receivingInfo.id;
              setState(() {});
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.settings,
            label: '设为默认',
          ),
          SlidableAction(
            onPressed: (c){
              //删除

              setState(() {});
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            label: '删除',
          ),
        ],
      ),
      child: ListTile(
        contentPadding: padding,
        leading: CircleAvatar(
          child: Text(receivingInfo.name[0]),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(receivingInfo.name,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            const SizedBox(width: 8,),
            Text(receivingInfo.phone),
            const SizedBox(width: 8,),
            if(_defaultReceivingInfoId == receivingInfo.id)
              Container(decoration:BoxDecoration(border: Border.all(color: Colors.blue, width: 0.5)),child: const Text(' 默认 ',style: TextStyle(color: Colors.blue),),),
          ],
        ),
        subtitle: Text(receivingInfo.address,maxLines: 4,overflow: TextOverflow.ellipsis,),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {

          },
        ),
      )
    );
  }

  Future<void> _fetchData() async {
    ReceivingInfo receivingInfo = ReceivingInfo(
      id: '1',
      name: '张三',
      phone: '12345678901',
      address: '山东省 济南市 历城区 港沟街道 舜华路1500号山东大学软件园校区教学楼',
    );
    _receivingInfoList = [receivingInfo,receivingInfo,receivingInfo,receivingInfo];
  }
}