import '../commodity.dart';
import '../receiving_info.dart';

class OrderCommodityDetailedInfo{
  String oid;
  Commodity commodity;
  ReceivingInfo receivingInfo;
  //订单总价
  double totalPrice;
  //商品数量
  int quantity;

  OrderCommodityDetailedInfo({
    required this.oid,
    required this.commodity,
    required this.receivingInfo,
    required this.totalPrice,
    required this.quantity,
  });

  factory OrderCommodityDetailedInfo.fromJson(Map<String, dynamic> json) {
    return OrderCommodityDetailedInfo(
      oid: json['orderId'] as String,
      commodity: Commodity.fromJson(json['commodity'] as Map<String, dynamic>),
      receivingInfo: ReceivingInfo.fromJson(json['user'] as Map<String, dynamic>),
      totalPrice: json['totalPrice'] as double,
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': oid,
      'commodity': commodity.toJson(),
      'user': receivingInfo.toJson(),
      'totalPrice': totalPrice,
      'quantity': quantity,
    };
  }
}