import 'package:live_video_commerce/entity/commodity/commodity_specification.dart';

class Commodity{
  //商品id
  int cid;
  //商品名称
  String commodityName;
  //主播id
  String anchorId;
  //主播名称
  String anchorName;
  //商品最低单价
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
    List<CommoditySpecification> specification = (json['specification'] as List<dynamic>).map((e) => CommoditySpecification.fromJson(e)).toList();
    //price为specification的最小值
    double price = specification[0].price;
    for (var element in specification) {
      if(element.price < price){
        price = element.price;
      }
    }
    List<String> images = (json['imageUrl'] as List).map((item) => item as String).toList();

    return Commodity(
      cid: json['cid'] as int,
      commodityName: json['commodityName'] as String,
      anchorId: json['anchorId'] as String,
      anchorName: json['anchorName'] as String,
      price: price,
      freight: json['freight'] as double,
      specification: specification,
      imageUrl: images,
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

  //深拷贝
  Commodity clone() {
    return Commodity(
      cid: cid,
      commodityName: commodityName,
      anchorId: anchorId,
      anchorName: anchorName,
      price: price,
      freight: freight,
      specification: specification.map((e) => e.clone()).toList(),
      imageUrl: imageUrl,
    );
  }

}