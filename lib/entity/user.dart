class User {
  String name;
  String email;
  String password;
  String phone;
  String address;
  String avatar;
  String role;
  String status;
  String createdAt;
  String updatedAt;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
    required this.avatar,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      avatar: json['avatar'] as String,
      role: json['role'] as String,
      status: json['status'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }

  Map<String, dynamic> toJson () {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'address': address,
      'avatar': avatar,
      'role': role,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class OrderedUser{
  String name;
  String phone;
  String address;

  OrderedUser({
    required this.name,
    required this.phone,
    required this.address,
  });

  factory OrderedUser.fromJson(Map<String, dynamic> json) {
    return OrderedUser(
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