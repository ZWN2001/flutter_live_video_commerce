import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../api/api.dart';
import '../../../entity/order/order.dart';
import '../../../entity/result.dart';
import '../../../utils/constant_string_utils.dart';

class OrderToShip extends StatefulWidget {
  const OrderToShip({super.key});

  @override
  OrderToShipState createState() => OrderToShipState();
}

class OrderToShipState extends State<OrderToShip> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  final List<OrderMini> _orderMiniList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('待付款'),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        physics: const ClampingScrollPhysics(),
        header: ConstantStringUtils.classicHeader,
        footer: ConstantStringUtils.classicFooter,
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child:  ListView(
          children: [

          ],
        ),
      ),
    );
  }

  Future<void> _fetchData() async{
    ResultEntity<List<OrderMini>> result = await CommodityAPI.orderToShip();
    if(result.success){
      _orderMiniList.addAll(result.data!);
      if(mounted) {
        setState(() {});
      }
    }
  }

  void _onRefresh() async{
    _orderMiniList.clear();
    await _fetchData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    //TODO:load more
    await Future.delayed(const Duration(milliseconds: 1000));
    if(mounted) {
      setState(() {});
    }
    _refreshController.loadComplete();
  }
}

