class OrderCommodityInfo{
  String oid;
  String uid;
  int commodityId;
  int receivingInfoId;
  int specificationId;
  int quantity;
  double totalPrice;

  OrderCommodityInfo({
    required this.oid,
    required this.uid,
    required this.commodityId,
    required this.receivingInfoId,
    required this.specificationId,
    required this.quantity,
    required this.totalPrice,
  });

  factory OrderCommodityInfo.fromJson(Map<String, dynamic> json) {
    return OrderCommodityInfo(
      oid: json['orderId'] as String,
      uid: json['userId'] as String,
      commodityId: json['commodityId'] as int,
      receivingInfoId: json['receivingInfoId'] as int,
      specificationId: json['specificationId'] as int,
      quantity: json['quantity'] as int,
      totalPrice: json['totalPrice'] as double,
    );
  }

  Map<String, dynamic> toJson () {
    return {
      'orderId': oid,
      'userId': uid,
      'commodityId': commodityId,
      'receivingInfoId': receivingInfoId,
      'specificationId': specificationId,
      'quantity': quantity,
      'totalPrice': totalPrice,
    };
  }
}