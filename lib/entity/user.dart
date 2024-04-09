class User {
  String uid;
  String nickname;
  String password;
  String avatar;

  User({
    required this.uid,
    required this.nickname,
    required this.password,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] as String,
      nickname: json['name'] ?? '未设置用户名',
      password: json['password'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }

  Map<String, dynamic> toJson () {
    return {
      'uid': uid,
      'name': nickname,
      'password': password,
      'avatar': avatar,
    };
  }

  static User empty() {
    return User(
      uid: '',
      nickname: '',
      password: '',
      avatar: '',
    );
  }

  @override
  String toString() {
    return 'User{uid: $uid, nickname: $nickname, password: $password, avatar: $avatar}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && uid == other.uid;

  @override
  int get hashCode => uid.hashCode;
}

