import 'package:flutter/cupertino.dart';

import '../entity/user.dart';


typedef UserStatusChangeCallback = void Function(User? user);

class UserStatus {
  static bool _isLogin = false;
  static LoginStatus _loginStatus = LoginStatus.logout;
  // static UserRole _role = UserRole.common;
  static String _token = '';

  ///[isLogin]为true时一定不为空, 为false一定为空
  static User? _user;

  static bool get isLogin => _isLogin;

  static LoginStatus get loginStatus => _loginStatus;

  // static bool get isAdmin => _role == UserRole.admin;
  //
  // static UserRole get role => _role;

  static String get token => _token;

  static User? get user => _user;

  static final Set<UserStatusChangeCallback> _callbacks = {};

  static void changeState({User? user, String? token, bool doCallback = true}) {
    _user = user;
    if (user == null) {
      _isLogin = false;
      _loginStatus = LoginStatus.logout;
      // _role = UserRole.common;
      _token = '';
    } else {
      _isLogin = true;
      _loginStatus = LoginStatus.login;
      // _role = user.role == 'SYS_ADMIN' ? UserRole.admin : UserRole.common;
      _token = token ?? _token;
    }
    for (var callback in _callbacks) {
      callback(user);
    }
  }

  ///为防止内存泄露不公开该方法
  static void _addListener(UserStatusChangeCallback fun) {
    _callbacks.add(fun);
  }

  static void _removeListener(UserStatusChangeCallback fun) {
    _callbacks.remove(fun);
  }
}

mixin UserStateMixin<T extends StatefulWidget> on State<T> {
  @override
  @mustCallSuper
  void initState() {
    super.initState();
    UserStatus._addListener(onUserStateChanged);
  }

  void onUserStateChanged(User? user);

  @override
  @mustCallSuper
  void dispose() {
    UserStatus._removeListener(onUserStateChanged);
    super.dispose();
  }
}

enum LoginStatus {
  login,
  expired,
  logout;
}

