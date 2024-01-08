class Commodity{
  //商品id
  String id;
  //商品名称
  String name;
  //主播id
  String anchorId;
  //主播名称
  String anchorName;
  //商品单价
  double price;
  //运费
  double freight;
  //商品规格
  String specification;
  //商品图片
  String image;

  Commodity({
    required this.id,
    required this.name,
    required this.anchorId,
    required this.anchorName,
    required this.price,
    required this.freight,
    required this.specification,
    required this.image,
  });

  factory Commodity.fromJson(Map<String, dynamic> json) {
    return Commodity(
      id: json['id'] as String,
      name: json['name'] as String,
      anchorId: json['anchorId'] as String,
      anchorName: json['anchorName'] as String,
      price: json['price'] as double,
      freight: json['freight'] as double,
      specification: json['specification'] as String,
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson () {
    return {
      'id': id,
      'name': name,
      'anchorId': anchorId,
      'anchorName': anchorName,
      'price': price,
      'freight': freight,
      'specification': specification,
      'image': image,
    };
  }

}