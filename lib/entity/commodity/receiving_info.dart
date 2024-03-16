class ReceivingInfo{
  int id;
  String uid;
  String receiver;
  String phone;
  String locateArea;
  String detailedAddress;

  ReceivingInfo({
    required this.id,
    required this.uid,
    required this.receiver,
    required this.phone,
    required this.locateArea,
    required this.detailedAddress,
  });

  factory ReceivingInfo.fromJson(Map<String, dynamic> json) {
    return ReceivingInfo(
      id: json['id'] as int,
      uid: json['uid'] as String,
      receiver: json['receiver'] as String,
      phone: json['phone'] as String,
      locateArea: json['locateArea'] as String,
      detailedAddress: json['detailedAddress'] as String,
    );
  }

  Map<String, dynamic> toJson () {
    return {
      'id': id,
      'uid': uid,
      'receiver': receiver,
      'phone': phone,
      'locateArea': locateArea,
      'detailedAddress': detailedAddress,
    };
  }

  static ReceivingInfo empty() {
    return ReceivingInfo(
      id: 0,
      uid: '',
      receiver: '',
      phone: '',
      locateArea: '',
      detailedAddress: '',
    );
  }

  @override
  String toString() {
    return 'ReceivingInfo{id: $id, receiver: $receiver, phone: $phone, locateArea: $locateArea, detailedAddress: $detailedAddress}';
  }
}