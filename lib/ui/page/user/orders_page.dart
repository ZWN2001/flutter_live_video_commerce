import 'package:flutter/material.dart';
import 'package:live_video_commerce/entity/order/order.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../api/api.dart';
import '../../../entity/result.dart';
import '../../../utils/constant_string_utils.dart';
import '../../widget/my_order_card.dart';


class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => OrdersPageState();
}

class OrdersPageState extends State<OrdersPage> {
  List<OrderMini> orderList = [];
  final RefreshController _refreshController = RefreshController(
      initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("全部订单"),
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
        child: ListView.builder(
          itemBuilder: (context, index) => MyOrderCard(order: orderList[index]),
          itemCount: orderList.length,),
      ),
    );
  }

  _fetchData() async {
    ResultEntity<List<OrderMini>> result = await CommodityAPI.getOrders();
    if (result.success) {
      orderList.clear();
      orderList.addAll(result.data!);
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _onRefresh() async {
    await _fetchData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    //TODO:load more
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      setState(() {});
    }
    _refreshController.loadComplete();
  }

}