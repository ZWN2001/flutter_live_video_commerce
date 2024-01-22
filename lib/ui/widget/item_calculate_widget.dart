/// 加减按钮

import 'package:flutter/material.dart';

class ItemCalculateWidget extends StatefulWidget {
  final int count;
  final Function(int) onCountChanged;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final double? size;
  const ItemCalculateWidget({
    Key? key,
    required this.onCountChanged,
    required this.count,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.size,
  }) : super(key: key);

  @override
  State<ItemCalculateWidget> createState() => _ItemCalculateWidgetState();
}

class _ItemCalculateWidgetState extends State<ItemCalculateWidget> {
  late int count;
  @override
  void initState() {
    super.initState();
    count = widget.count;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget.mainAxisAlignment ?? MainAxisAlignment.start,
      crossAxisAlignment: widget.crossAxisAlignment ?? CrossAxisAlignment.center,
      children: <Widget>[
        _reduceBtn(context),
        const SizedBox(width: 8,),
        _numArea(context),
        const SizedBox(width: 8,),
        _addBtn(context)
      ],
    );
  }

  // 减少按钮
  Widget _reduceBtn(context) {
    return InkWell(
      onTap: () {
        if (count > 1) {
          count --;
          setState(() {});
          widget.onCountChanged(-1);
        }
      },
      child: Container(
        width: widget.size ?? 32,
        height: widget.size ?? 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: count == 1 ? Colors.grey[300] : Colors.white,
          borderRadius:  const BorderRadius.all(Radius.circular(6.0)),
        ),
        child: Icon(Icons.remove, size: 18,color: count == 1 ? Colors.grey : Colors.blue,),
      ),
    );
  }

  // 商品数量
  Widget _numArea(context) {
    return Container(
      width: widget.size == null ? 48 : widget.size! * 1.5,
      height: widget.size == null ? 30 : widget.size! -2,
      alignment: Alignment.center,
      color: Colors.white,
      child: Text('$count'),
    );
  }

  // 加号按钮
  Widget _addBtn(context) {
    return InkWell(
      onTap: () {
        count ++;
        widget.onCountChanged(1);
        setState(() {});
      },
      child: Container(
        width: widget.size ?? 32,
        height: widget.size ?? 32,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius:  BorderRadius.all(Radius.circular(6.0)),
        ),
        child: const Icon(Icons.add, size: 18,color: Colors.blue,),
      ),
    );
  }
}
