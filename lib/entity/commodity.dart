import 'package:live_video_commerce/entity/commodity_specification.dart';

class Commodity{
  //商品id
  String cid;
  //商品名称
  String commodityName;
  //主播id
  String anchorId;
  //主播名称
  String anchorName;
  //商品单价
  double price;
  //运费
  double freight;
  //商品规格
  List<CommoditySpecification> specification;
  //商品图片
  List<String> imageUrl;

  Commodity({
    required this.cid,
    required this.commodityName,
    required this.anchorId,
    required this.anchorName,
    required this.price,
    required this.freight,
    required this.specification,
    required this.imageUrl,
  });

  factory Commodity.fromJson(Map<String, dynamic> json) {
    return Commodity(
      cid: json['id'] as String,
      commodityName: json['name'] as String,
      anchorId: json['anchorId'] as String,
      anchorName: json['anchorName'] as String,
      price: json['price'] as double,
      freight: json['freight'] as double,
      specification: (json['specification'] as List<dynamic>).map((e) => CommoditySpecification.fromJson(e)).toList(),
      imageUrl: json['image'] as List<String>,
    );
  }

  Map<String, dynamic> toJson () {
    return {
      'id': cid,
      'name': commodityName,
      'anchorId': anchorId,
      'anchorName': anchorName,
      'price': price,
      'freight': freight,
      'specification': specification,
      'image': imageUrl,
    };
  }

}