import 'package:live_video_commerce/entity/commodity.dart';
import 'package:live_video_commerce/entity/user.dart';

class Order{
  String orderId;
  Commodity commodity;
  OrderedUser user;
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
  int quantity;

  Order({
    required this.orderId,
    required this.commodity,
    required this.user,
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
      orderId: json['orderId'] as String,
      commodity: Commodity.fromJson(json['commodity']),
      user: OrderedUser.fromJson(json['user']),
      status: json['status'] as String,
      createdAt: json['createdAt'] as String,
      payAt: json['payAt'] as String,
      shipAt: json['shipAt'] as String,
      completeAt: json['completeAt'] as String,
      totalPrice: json['totalPrice'] as double,
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson () {
    return {
      'orderId': orderId,
      'commodity': commodity.toJson(),
      'user': user.toJson(),
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