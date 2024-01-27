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

  @override
  String toString() {
    return 'User{uid: $uid, nickname: $nickname, password: $password, avatar: $avatar}';
  }
}

