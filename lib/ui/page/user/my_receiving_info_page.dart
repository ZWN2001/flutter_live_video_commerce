import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:live_video_commerce/ui/page/user/edit_receiving_info_page.dart';

import '../../../api/api.dart';
import '../../../entity/commodity/receiving_info.dart';
import '../../../entity/result.dart';

class MyReceivingInfoPage extends StatefulWidget {
  const MyReceivingInfoPage({super.key});

  @override
  MyReceivingInfoPageState createState() => MyReceivingInfoPageState();
}

class MyReceivingInfoPageState extends State<MyReceivingInfoPage> {
  final List<ReceivingInfo> _receivingInfoList = [];
  int _defaultReceivingInfoId = 0;

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
                        Get.to(()=>EditReceivingInfoPage(
                          receivingInfo: null,
                          isDefaultReceivingInfo: false,
                          onEditSuccess: (){
                            _fetchData();
                          },
                        ));
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
              _receivingInfoList.remove(receivingInfo);
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
          child: Text(receivingInfo.receiver[0]),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(receivingInfo.receiver,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            const SizedBox(width: 8,),
            Text(receivingInfo.phone),
            const SizedBox(width: 8,),
            if(_defaultReceivingInfoId == receivingInfo.id)
              Container(decoration:BoxDecoration(border: Border.all(color: Colors.blue, width: 0.5)),child: const Text(' 默认 ',style: TextStyle(color: Colors.blue),),),
          ],
        ),
        subtitle: Text(receivingInfo.detailedAddress,maxLines: 4,overflow: TextOverflow.ellipsis,),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            Get.to(()=>EditReceivingInfoPage(
              receivingInfo: receivingInfo,
              isDefaultReceivingInfo: _defaultReceivingInfoId == receivingInfo.id,
              onEditSuccess: (){
                _fetchData();
              },
            ));
          },
        ),
      )
    );
  }

  Future<void> _fetchData() async {
    ResultEntity<List<ReceivingInfo>> result = await ReceivingInfoAPI.getReceivingInfos();
    if(result.success){
      _receivingInfoList.addAll(result.data!);
      if(mounted) {
        setState(() {});
      }
    }
  }
}