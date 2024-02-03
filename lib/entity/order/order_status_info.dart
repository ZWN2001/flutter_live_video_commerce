class OrderStatusInfo{
  String oid;
  int orderStatus;
  //订单创建时间
  String createAt;
  //订单支付时间
  String payAt;
  //订单发货时间
  String shipAt;
  //订单完成时间
  String completeAt;

  OrderStatusInfo({
    required this.oid,
    required this.orderStatus,
    required this.createAt,
    required this.payAt,
    required this.shipAt,
    required this.completeAt,
  });

  factory OrderStatusInfo.fromJson(Map<String, dynamic> json) {
    return OrderStatusInfo(
      oid: json['orderId'] as String,
      orderStatus: json['status'] as int,
      createAt: json['createdAt'] as String,
      payAt: json['payAt'] ?? '',
      shipAt: json['shipAt'] ?? '',
      completeAt: json['completeAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson () {
    return {
      'orderId': oid,
      'status': orderStatus,
      'createdAt': createAt,
      'payAt': payAt,
      'shipAt': shipAt,
      'completeAt': completeAt,
    };
  }
}