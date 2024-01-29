import 'package:live_video_commerce/entity/commodity.dart';
import 'package:live_video_commerce/entity/receiving_info.dart';

import 'order_commodity_detailed_info.dart';
import 'order_commodity_info.dart';
import 'order_status_info.dart';

class Order{
  OrderStatusInfo orderStatusInfo;
  List<OrderCommodityInfo> orderCommodityInfo;

  Order({
    required this.orderStatusInfo,
    required this.orderCommodityInfo,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderStatusInfo: OrderStatusInfo.fromJson(json['orderStatusInfo'] as Map<String, dynamic>),
      orderCommodityInfo: (json['orderCommodityInfo'] as List<dynamic>).map((e) => OrderCommodityInfo.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderStatusInfo': orderStatusInfo.toJson(),
      'orderCommodityInfo': orderCommodityInfo.map((e) => e.toJson()).toList(),
    };
  }


}

class OrderMini{
  String oid;
  Commodity commodity;
  int quantity;
  double totalPrice;
  int orderStatus;

  OrderMini({
    required this.oid,
    required this.commodity,
    required this.quantity,
    required this.totalPrice,
    required this.orderStatus,
  });

  factory OrderMini.fromJson(Map<String, dynamic> json) {
    return OrderMini(
      oid: json['orderId'] as String,
      commodity: Commodity.fromJson(json['commodity'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      totalPrice: json['totalPrice'] as double,
      orderStatus: json['status'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': oid,
      'commodity': commodity.toJson(),
      'quantity': quantity,
      'totalPrice': totalPrice,
      'status': orderStatus,
    };
  }
}

class OrderDetail{
  OrderStatusInfo orderStatusInfo;
  List<OrderCommodityDetailedInfo> orderCommodityDetailedInfo;

  OrderDetail({
    required this.orderStatusInfo,
    required this.orderCommodityDetailedInfo,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      orderStatusInfo: OrderStatusInfo.fromJson(json['orderStatusInfo'] as Map<String, dynamic>),
      orderCommodityDetailedInfo: (json['orderCommodityDetailedInfo'] as List<dynamic>).map((e) => OrderCommodityDetailedInfo.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderStatusInfo': orderStatusInfo.toJson(),
      'orderCommodityDetailedInfo': orderCommodityDetailedInfo.map((e) => e.toJson()).toList(),
    };
  }


}