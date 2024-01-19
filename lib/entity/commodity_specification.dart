class CommoditySpecification{
  String cid;
  String id;
  String imageUrl;
  String specification;

  CommoditySpecification({
    required this.cid,
    required this.id,
    required this.imageUrl,
    required this.specification,
  });

  factory CommoditySpecification.fromJson(Map<String, dynamic> json) {
    return CommoditySpecification(
      cid: json['cid'] as String,
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      specification: json['specification'] as String,
    );
  }

  Map<String, dynamic> toJson () {
    return {
      'cid': cid,
      'id': id,
      'imageUrl': imageUrl,
      'specification': specification,
    };
  }
}