import 'package:live_video_commerce/entity/commodity.dart';
import 'package:live_video_commerce/entity/receiving_info.dart';

class Order{
  String oid;
  List<Commodity> commodity;
  ReceivingInfo receivingInfo;
  String status;
  //订单创建时间
  String createdAt;
  //订单支付时间
  String payAt;
  //订单发货时间
  String shipAt;
  //订单完成时间
  String completeAt;
  //订单总价
  double totalPrice;
  //商品数量
  List<int> quantity;

  Order({
    required this.oid,
    required this.commodity,
    required this.receivingInfo,
    required this.status,
    required this.createdAt,
    required this.payAt,
    required this.shipAt,
    required this.completeAt,
    required this.totalPrice,
    required this.quantity,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      oid: json['orderId'] as String,
      commodity: (json['commodity'] as List<dynamic>).map((e) => Commodity.fromJson(e)).toList(),
      receivingInfo: ReceivingInfo.fromJson(json['user']),
      status: json['status'] as String,
      createdAt: json['createdAt'] as String,
      payAt: json['payAt'] as String,
      shipAt: json['shipAt'] as String,
      completeAt: json['completeAt'] as String,
      totalPrice: json['totalPrice'] as double,
      quantity: (json['quantity'] as List<dynamic>).map((e) => e as int).toList(),
    );
  }

  Map<String, dynamic> toJson () {
    return {
      'orderId': oid,
      'commodity': commodity.map((e) => e.toJson()).toList(),
      'user': receivingInfo.toJson(),
      'status': status,
      'createdAt': createdAt,
      'payAt': payAt,
      'shipAt': shipAt,
      'completeAt': completeAt,
      'totalPrice': totalPrice,
      'quantity': quantity,
    };
  }


}