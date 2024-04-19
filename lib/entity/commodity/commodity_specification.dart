import '../../api/server.dart';

class CommoditySpecification{
  int cid;
  int id;
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
    String imageUrl = json['imageUrl'];
    imageUrl = imageUrl.replaceAll("localhost", Server.hostIp);
    return CommoditySpecification(
      cid: json['cid'] as int,
      id: json['id'] as int,
      imageUrl: imageUrl,
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