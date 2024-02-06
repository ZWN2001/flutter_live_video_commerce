class ShoppingCartItem {
  String uid;
  int cid;
  int sid;
  int counts;
  String addTime;

ShoppingCartItem({
    required this.uid,
    required this.cid,
    required this.sid,
    required this.counts,
    required this.addTime,
  });

  factory ShoppingCartItem.fromJson(Map<String, dynamic> json) {
    return ShoppingCartItem(
      uid: json['uid'] as String,
      cid: json['cid'] as int,
      sid: json['sid'] as int,
      counts: json['counts'] as int,
      addTime: json['addTime'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'cid': cid,
      'sid': sid,
      'counts': counts,
      'addTime': addTime,
    };
  }
}