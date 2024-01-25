import 'package:flutter/material.dart';
import 'package:live_video_commerce/entity/receiving_info.dart';

class EditReceivingInfoPage extends StatefulWidget {
  final ReceivingInfo? receivingInfo;
  final bool isDefaultReceivingInfo;
  const EditReceivingInfoPage({super.key, this.receivingInfo, required this.isDefaultReceivingInfo});

  @override
  EditReceivingInfoPageState createState() => EditReceivingInfoPageState();
}

class EditReceivingInfoPageState extends State<EditReceivingInfoPage> {
  ReceivingInfo? _receivingInfo;
  late bool _isDefaultReceivingInfo;
  bool groupValue = false;

  @override
  void initState() {
    super.initState();
    _receivingInfo = widget.receivingInfo;
    _isDefaultReceivingInfo = widget.isDefaultReceivingInfo;
    if(_isDefaultReceivingInfo){
      groupValue = true;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _receivingInfo == null ? const Text('新增收货信息') : const Text('编辑收货信息'),
      ),
      body: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("地址信息",style: TextStyle(fontWeight: FontWeight.bold),),
                  const SizedBox(height: 8,),
                  Row(
                    children: [
                      const Text("收件人   "),
                      const SizedBox(width: 8,),
                      Expanded(
                        child: TextField(
                          autofocus: true,
                          controller: TextEditingController(text: _receivingInfo?.name),
                          style: const TextStyle(
                            color: Color(0xff333333),
                            fontSize: 14.0,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
                            fillColor: Colors.grey[200],
                            filled: true,
                            border: const OutlineInputBorder(borderSide: BorderSide.none),
                            enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue, width: 1)),
                            hintText: '收件人姓名',
                          ),
                          onChanged: (value) {
                            _receivingInfo?.name = value;
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16,),
                  Row(
                    children: [
                      const Text("手机号   "),
                      const SizedBox(width: 8,),
                      Expanded(
                        child: TextField(
                          controller: TextEditingController(text: _receivingInfo?.phone),
                          style: const TextStyle(
                            color: Color(0xff333333),
                            fontSize: 14.0,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
                            fillColor: Colors.grey[200],
                            filled: true,
                            border: const OutlineInputBorder(borderSide: BorderSide.none),
                            enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue, width: 1)),
                            hintText: '收件人手机号',
                          ),
                          onChanged: (value) {
                            _receivingInfo?.phone = value;
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16,),
                  Row(
                    children: [
                      const Text("省市区   "),
                      const SizedBox(width: 8,),
                      Expanded(
                        child: TextField(
                          controller: TextEditingController(text: _receivingInfo?.detailedAddress),
                          decoration: const InputDecoration(
                            hintText: '省市区',
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            _receivingInfo?.detailedAddress = value;
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16,),
                  Row(
                    children: [
                      const Text("详细地址"),
                      const SizedBox(width: 8,),
                      Expanded(
                        child: TextField(
                          maxLines: 4,
                          style: const TextStyle(
                            color: Color(0xff333333),
                            fontSize: 14.0,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
                            fillColor: Colors.grey[200],
                            filled: true,
                            border: const OutlineInputBorder(borderSide: BorderSide.none),
                            enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue, width: 1)),
                            hintText: '详细地址',
                          ),
                          onChanged: (value) {
                            // _receivingInfo?.detailAddress = value;
                          },
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: _isDefaultReceivingInfo,
                          onChanged: (value) {
                            setState(() {
                              _isDefaultReceivingInfo = value!;
                            });
                          }
                      ),
                      const SizedBox(width: 14,),
                      const Text("设为默认地址"),
                    ],
                  )
                ],
              ),
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
                      child: const Text('保存'),
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
}