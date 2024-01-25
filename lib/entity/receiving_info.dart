class ReceivingInfo{
  String id;
  String name;
  String phone;
  String locateArea;
  String detailedAddress;

  ReceivingInfo({
    required this.id,
    required this.name,
    required this.phone,
    required this.locateArea,
    required this.detailedAddress,
  });

  factory ReceivingInfo.fromJson(Map<String, dynamic> json) {
    return ReceivingInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      locateArea: json['locateArea'] as String,
      detailedAddress: json['address'] as String,
    );
  }

  Map<String, dynamic> toJson () {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'locateArea': locateArea,
      'address': detailedAddress,
    };
  }
}