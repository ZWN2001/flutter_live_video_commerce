import 'package:live_video_commerce/entity/commodity.dart';

class OrderedCommodity{
  Commodity commodity;
  int count;
  int selectedSpecificationIndex;

  OrderedCommodity({
    required this.commodity,
    required this.count,
    required this.selectedSpecificationIndex,
  });

  factory OrderedCommodity.fromJson(Map<String, dynamic> json) {
    return OrderedCommodity(
      commodity: Commodity.fromJson(json['commodity']),
      count: json['count'] as int,
      selectedSpecificationIndex: json['selectedSpecificationIndex'] as int,
    );
  }

  Map<String, dynamic> toJson () {
    return {
      'commodity': commodity,
      'count': count,
      'selectedSpecificationIndex': selectedSpecificationIndex,
    };
  }
}