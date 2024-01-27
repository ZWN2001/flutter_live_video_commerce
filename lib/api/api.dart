import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:live_video_commerce/api/server.dart';
import 'package:dio/dio.dart';

import '../entity/live_room.dart';
import '../entity/result.dart';
import '../entity/user.dart';
import '../state/user_status.dart';
import '../utils/http_utils.dart';
import '../utils/store_utils.dart';

class UserAPI{
  static const String _login = '${Server.user}/login';
  static const String _register = '${Server.user}/register';
  static const String _refreshToken = '${Server.user}/refresh';

  static const String _userInfo = '${Server.user}/info';

  ///使用post请求对用户信息进行更新
  static const String _updateProfile = '${Server.user}/info';

  static String get token => UserStatus.token;

  static bool autoLogin() {
    String token = Store.getString('token');
    String userJson = Store.getString('user');
    if (token.isEmpty || userJson.isEmpty) {
      return false;
    } else {
      User user = User.fromJson(jsonDecode(userJson));
      UserStatus.changeState(user: user, token: "Bearer:$token");
      return true;
    }
  }

  static Future<ResultEntity<void>> login(
      {required String uid, required String password}) async {
    Response response = await HttpUtils.post(_login,
        data:
        FormData.fromMap({'uid': uid, 'loginKey': password,}));
    if (response.valid) {
      String token = response.data['data']['token'];
      User user = User.fromJson(jsonDecode(response.data['data']['user']));
      UserStatus.changeState(
          user: user, token: "Bearer:$token");
      _storeUserInfo(user: user);
      return ResultEntity.succeed();
    }
    return ResultEntity.error();
  }

  static Future<ResultEntity<void>> logout() async {
    UserStatus.changeState(user: null);
    await Store.removeKeys(['user', 'token']);
    return ResultEntity.succeed();
  }

  static Future<ResultEntity<void>> register(
      {required String uid, required String password}) async {
    Response response = await HttpUtils.post(_register,
        data: FormData.fromMap({
          'uid': uid,
          'password': password,
          'isCommon': true,
        }));
    if(response.valid){
      return ResultEntity.succeed();
    }
    return ResultEntity.error(message: response.data['message']);
  }

  static Future<User?> getUserInfo() async {
    try {
      Response response = await HttpUtils.get(_userInfo,
          options: Options(headers: {'Token': UserAPI.token}));
      if(!response.valid) {
        return null;
      }
      var data = response.data['data'];
      return User.fromJson(jsonDecode(data));
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<ResultEntity<void>> updateUserProfile({
    String? nickname,
    String? avatar,
    bool? gender,
  }) async {
    return ResultEntity.error();
  }

  // static Future<ResultEntity<void>> refreshUserStatus() async {
  //   var res = await refreshToken();
  //   if (res.code == SC.refreshTokenWrong) {
  //     return res;
  //   } else {
  //     String token = res.data!;
  //     User? user = await _userInfoWithCertainToken(token);
  //     if (user == UserStatus.user) {
  //       UserStatus.changeState(token: token, user: user, doCallback: false);
  //     } else {
  //       UserStatus.changeState(token: token, user: user);
  //     }
  //     _storeUserInfo(user: user);
  //     return ResultEntity.succeed();
  //   }
  // }

  static Future<ResultEntity<String>> refreshToken() async {
    try {
      Response response = await HttpUtils.post(_refreshToken,
          data: FormData.fromMap(
              {'token': UserAPI.token}));
      if (response.valid) {
        await _storeUserInfo(
            token: response.data['data'][0],
            );
        return ResultEntity.succeed(data: response.data['data'][0]);
      } else {
        return ResultEntity.fromSC(SC.refreshTokenWrong);
      }
    } catch (e) {
      return ResultEntity.error();
    }
  }

  static Future<void> _storeUserInfo(
      { User? user,
        String? token,
      }) async {
    if (user != null) {
      await Store.set('user', jsonEncode(user));
    }
    if (token != null) {
      await Store.set('token', token);
    }
  }
}

class LiveRoomAPI{
  static const String _liveRecommend = '${Server.live}/recommend';
  static const String _liveList = '${Server.live}/list';
  static const String _liveInfo = '${Server.live}/info';
  static const String _liveAddress = '${Server.live}/address';
  static const String _barrageAddress = '${Server.live}/barrageAddress';

  static Future<ResultEntity<List<LiveRoom>>> getRecommendLiveRooms() async {
    try {
      //TODO
      return ResultEntity.error();
    } catch (e) {
      return ResultEntity.error();
    }
  }

  ///获取某板块直播间列表
  static Future<ResultEntity<List<LiveRoom>>> getLiveRooms() async {
    try {
      //TODO
      return ResultEntity.error();
    } catch (e) {
      return ResultEntity.error();
    }
  }

  ///获取直播间信息
  static Future<ResultEntity<LiveRoom>> getLiveRoomInfo(int id) async {
    try {
      //TODO
      return ResultEntity.error();
    } catch (e) {
      return ResultEntity.error();
    }
  }

  ///获取直播流地址
  static Future<ResultEntity<String>> getLiveAddress(int id) async {
    try {
      //TODO
      return ResultEntity.error();
    } catch (e) {
      return ResultEntity.error();
    }
  }

  ///获取弹幕地址
  static Future<ResultEntity<String>> getBarrageAddress(int id) async {
    try {
      //TODO
      return ResultEntity.error();
    } catch (e) {
      return ResultEntity.error();
    }
  }
}

class CommerceAPI{
  static const String _commerce = '${Server.commerce}/liveRoomCommerce';
  static const String _commerceDetail = '${Server.commerce}/commerceDetail';
  static const String _shoppingHistory = '${Server.commerce}/history';
  static const String _order = '${Server.commerce}/order';
  static const String _orderDetail = '${Server.commerce}/orderDetail';
  static const String _orderPay = '${Server.commerce}/orderPay';
  static const String _orderCancel = '${Server.commerce}/orderCancel';
}