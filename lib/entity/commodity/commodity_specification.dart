class CommoditySpecification{
  String cid;
  String id;
  String imageUrl;
  String specification;
  double price;

  CommoditySpecification({
    required this.cid,
    required this.id,
    required this.imageUrl,
    required this.specification,
    required this.price,
  });

  factory CommoditySpecification.fromJson(Map<String, dynamic> json) {
    return CommoditySpecification(
      cid: json['cid'] as String,
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      specification: json['specification'] as String,
      price: json['price'] as double,
    );
  }

  Map<String, dynamic> toJson () {
    return {
      'cid': cid,
      'id': id,
      'imageUrl': imageUrl,
      'specification': specification,
      'price': price,
    };
  }

  //深拷贝
  CommoditySpecification clone() {
    return CommoditySpecification(
      cid: cid,
      id: id,
      imageUrl: imageUrl,
      specification: specification,
      price: price,
    );
  }
}