class ReceivingInfo{
  String id;
  String name;
  String phone;
  String address;

  ReceivingInfo({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
  });

  factory ReceivingInfo.fromJson(Map<String, dynamic> json) {
    return ReceivingInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
    );
  }

  Map<String, dynamic> toJson () {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
    };
  }
}