class ReceivingInfo{
  String name;
  String phone;
  String address;

  ReceivingInfo({
    required this.name,
    required this.phone,
    required this.address,
  });

  factory ReceivingInfo.fromJson(Map<String, dynamic> json) {
    return ReceivingInfo(
      name: json['name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
    );
  }

  Map<String, dynamic> toJson () {
    return {
      'name': name,
      'phone': phone,
      'address': address,
    };
  }
}