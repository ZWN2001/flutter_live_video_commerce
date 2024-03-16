import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:live_video_commerce/api/server.dart';
import 'package:dio/dio.dart';
import 'package:live_video_commerce/entity/commodity/shopping_cart_item.dart';
import 'package:live_video_commerce/entity/order/order.dart';

import '../entity/commodity/commodity.dart';
import '../entity/live_room.dart';
import '../entity/commodity/receiving_info.dart';
import '../entity/result.dart';
import '../entity/section.dart';
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
  // static const String _updateProfile = '${Server.user}/info';

  static String get token => UserStatus.token;
  static User? get user => UserStatus.user;

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
    UserStatus.changeState(user: null,token: '');
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
  // static const String _liveRecommend = '${Server.live}/recommend';
  static const String _liveSection = '${Server.live}/section';
  static const String _liveList = '${Server.live}/liveRoomList';
  static const String _liveInfo = '${Server.live}/liveRoomInfo';


  static Future<ResultEntity<List<Section>>> getSections() async {
    try {
      Response response = await HttpUtils.get(_liveSection);
      if(!response.valid) {
        return ResultEntity.error();
      }
      var data = response.data['data'];
      List<Section> sections = [];
      for (var item in data) {
        sections.add(Section.fromJson(item));
      }
      return ResultEntity.succeed(data: sections);
    } catch (e) {
      return ResultEntity.error();
    }
  }

  static Future<ResultEntity<List<LiveRoom>>> getRecommendLiveRooms() async {
    try {
      Response response = await HttpUtils.get(_liveSection,
          options: Options(headers: {'Token': UserAPI.token}));
      if(!response.valid) {
        return ResultEntity.error();
      }
      var data = response.data['data'];
      List<LiveRoom> rooms = [];
      for (var item in data) {
        rooms.add(LiveRoom.fromJson(item));
      }
      return ResultEntity.succeed(data: rooms);
    } catch (e) {
      return ResultEntity.error();
    }
  }

  ///获取某板块直播间列表
  static Future<ResultEntity<List<LiveRoomMini>>> getLiveRooms(int sid) async {
    try {
      Response response = await HttpUtils.get(_liveList, params: {'sid': sid});
      if(!response.valid) {
        return ResultEntity.error();
      }
      var data = response.data['data'];
      List<LiveRoomMini> rooms = [];
      for (var item in data) {
        rooms.add(LiveRoomMini.fromJson(item));
      }
      return ResultEntity.succeed(data: rooms);
    } catch (e) {
      debugPrint(e.toString());
      return ResultEntity.error();
    }
  }

  ///获取直播间信息
  static Future<ResultEntity<LiveRoom>> getLiveRoomInfo(int rid) async {
    try {
      Response response = await HttpUtils.get(_liveInfo, params: {'rid': rid});
      if(!response.valid) {
        return ResultEntity.error();
      }
      var data = response.data['data'];
      return ResultEntity.succeed(data: LiveRoom.fromJson(data));
    } catch (e) {
      debugPrint(e.toString());
      return ResultEntity.error();
    }
  }

}

class CommodityAPI{
  static const String _commodity = '${Server.commodity}/liveRoomCommodity';
  static const String _commodityDetail = '${Server.commodity}/commodityDetail';
  static const String _commodityBrowseHistory = '${Server.commodity}/commodityBrowseHistory';
  static const String _order = '${Server.commodity}/orders';
  static const String _orderDetail = '${Server.commodity}/orderDetail';
  static const String _orderCreate = '${Server.commodity}/orderCreate';
  static const String _orderPay = '${Server.commodity}/orderPay';
  static const String _orderCancel = '${Server.commodity}/orderCancel';
  static const String _shoppingCartAdd = '${Server.commodity}/shoppingCartAdd';
  static const String _shoppingCart = '${Server.commodity}/shoppingCart';
  static const String _shoppingCartDelete = '${Server.commodity}/shoppingCartDelete';
  static const String _orderToPay = '${Server.commodity}/orderToPay';
  static const String _orderToShip = '${Server.commodity}/orderToShip';
  static const String _orderToComplete = '${Server.commodity}/orderToComplete';

  static Future<ResultEntity<List<Commodity>>> getCommodities(int liveRoomId) async {
    try {
      Response response = await HttpUtils.get(_commodity,
          params: {'liveRoomId': liveRoomId});
      if(!response.valid){
        return ResultEntity.error();
      }
      List<Commodity> list = [];
      var data = response.data['data'];
      for (var item in data) {
        list.add(Commodity.fromJson(item));
      }
      return ResultEntity.succeed(data: list);
    } catch (e) {
      debugPrint(e.toString());
      return ResultEntity.error();
    }
  }

  static Future<ResultEntity<Commodity>> getCommodityDetail(int cid) async {
    try {
      Response response = await HttpUtils.get(_commodityDetail,
          params: {'cid': cid},
          options: Options(headers: {'Token': UserAPI.token}));
      if(!response.valid){
        return ResultEntity.error();
      }
      return ResultEntity.succeed(data: Commodity.fromJson(response.data['data']));
    } catch (e) {
      return ResultEntity.error();
    }
  }

  static Future<ResultEntity<List<OrderMini>>> getCommodityBrowseHistory() async {
    try {
      Response response = await HttpUtils.get(_commodityBrowseHistory,
          params: {'uid': UserAPI.user!.uid},
          options: Options(headers: {'Token': UserAPI.token}));
      if(!response.valid){
        return ResultEntity.error();
      }
      List<OrderMini> list = [];
      var data = response.data['data'];
      for (var item in data) {
        list.add(OrderMini.fromJson(item));
      }
      return ResultEntity.succeed(data: list);
    } catch (e) {
      return ResultEntity.error();
    }
  }

  static Future<ResultEntity<List<OrderMini>>> getOrders() async {
    try {
      Response response = await HttpUtils.get(_order,
          params: {'uid': UserAPI.user!.uid},
          options: Options(headers: {'Token': UserAPI.token}));
      if(!response.valid){
        return ResultEntity.error();
      }
      List<OrderMini> list = [];
      var data = response.data['data'];
      for (var item in data) {
        list.add(OrderMini.fromJson(item));
      }
      return ResultEntity.succeed(data: list);
    } catch (e) {
      return ResultEntity.error();
    }
  }

  static Future<ResultEntity<Order>> getOrderDetail(int cid) async {
    try {
      Response response = await HttpUtils.get(_orderDetail,
          params: {'cid': cid},
          options: Options(headers: {'Token': UserAPI.token}));
      if(!response.valid){
        return ResultEntity.error();
      }
      return ResultEntity.succeed(data: Order.fromJson(response.data['data']));
    } catch (e) {
      return ResultEntity.error();
    }
  }

  static Future<ResultEntity> orderCreate(Order order) async {
    try {
      Response response = await HttpUtils.post(_orderCreate,
          data: {'orderCommodityInfoJson': jsonEncode(order.toJson())},
          options: Options(headers: {'Token': UserAPI.token}));
      if(!response.valid){
        return ResultEntity.error();
      }
      return ResultEntity.succeed();
    } catch (e) {
      return ResultEntity.error();
    }
  }

  static Future<ResultEntity> orderPay(int oid) async {
    try {
      Response response = await HttpUtils.post(_orderPay,
          data: {'oid': oid},
          options: Options(headers: {'Token': UserAPI.token}));
      if(!response.valid){
        return ResultEntity.error();
      }
      return ResultEntity.succeed();
    } catch (e) {
      return ResultEntity.error();
    }
  }

  static Future<ResultEntity> orderCancel(int oid) async {
    try {
      Response response = await HttpUtils.post(_orderCancel,
          data: {'oid': oid},
          options: Options(headers: {'Token': UserAPI.token}));
      if(!response.valid){
        return ResultEntity.error();
      }
      return ResultEntity.succeed();
    } catch (e) {
      return ResultEntity.error();
    }
  }

  static Future<ResultEntity> shoppingCartAdd(ShoppingCartItem shoppingCartItem) async {
    try {
      Response response = await HttpUtils.post(_shoppingCartAdd,
          data: {'shoppingCartItemJsonString': jsonEncode(shoppingCartItem.toJson())},
          options: Options(headers: {'Token': UserAPI.token}));
      if(!response.valid){
        return ResultEntity.error();
      }
      return ResultEntity.succeed();
    } catch (e) {
      return ResultEntity.error();
    }
  }

  static Future<ResultEntity<Map<Commodity,int>>> getShoppingCart() async {
    try {
      Response response = await HttpUtils.get(_shoppingCart,
          options: Options(headers: {'token': UserAPI.token}));
      if(!response.valid){
        return ResultEntity.error(data: response.data);
      }
      Map<Commodity,int> map = {};
      Map data = response.data['data'];
      data.forEach((key, value) {
        Commodity commodity = Commodity.fromJson(json.decode(key));
        map[commodity] = value;
      });
      return ResultEntity.succeed(data: map);
    } catch (e) {
      return ResultEntity.error();
    }
  }

  //TODO
  static Future<ResultEntity> shoppingCartDelete(List<ShoppingCartItem> items) async {
    try {
      Response response = await HttpUtils.post(_shoppingCartDelete,
          data: {'listJsonString': jsonEncode(items.map((e) => e.toJson()).toList())},
          options: Options(headers: {'Token': UserAPI.token}));
      if(!response.valid){
        return ResultEntity.error();
      }
      return ResultEntity.succeed();
    } catch (e) {
      return ResultEntity.error();
    }
  }

  //_orderToPay
  static Future<ResultEntity<List<OrderMini>>> orderToPay() async {
    try {
      Response response = await HttpUtils.get(_orderToPay,
          options: Options(headers: {'Token': UserAPI.token}));
      if(response.valid){
        final List<OrderMini> orderMiniList = [];
        final List data = response.data['data'];
        for (var item in data) {
          orderMiniList.add(OrderMini.fromJson(item));
        }
        return ResultEntity.succeed(data: orderMiniList);
      }
      return ResultEntity.error();
    } catch (e) {
      return ResultEntity.error();
    }
  }

  static Future<ResultEntity<List<OrderMini>>> orderToShip() async {
    try {
      Response response = await HttpUtils.get(_orderToShip,
          options: Options(headers: {'Token': UserAPI.token}));
      if(response.valid){
        final List<OrderMini> orderMiniList = [];
        final List data = response.data['data'];
        for (var item in data) {
          orderMiniList.add(OrderMini.fromJson(item));
        }
        return ResultEntity.succeed(data: orderMiniList);
      }
      return ResultEntity.error();
    } catch (e) {
      return ResultEntity.error();
    }
  }

  static Future<ResultEntity<List<OrderMini>>> orderToComplete() async {
    try {
      Response response = await HttpUtils.get(_orderToComplete,
          options: Options(headers: {'Token': UserAPI.token}));
      if(response.valid){
        final List<OrderMini> orderMiniList = [];
        final List data = response.data['data'];
        for (var item in data) {
          orderMiniList.add(OrderMini.fromJson(item));
        }
        return ResultEntity.succeed(data: orderMiniList);
      }
      return ResultEntity.error();
    } catch (e) {
      return ResultEntity.error();
    }
  }
}

class ReceivingInfoAPI{
  static const String _receivingInfo = '${Server.receivingInfo}/receivingInfo';
  static const String _receivingInfoDetail = '${Server.receivingInfo}/receivingInfoDetail';
  static const String _receivingInfoAdd = '${Server.receivingInfo}/receivingInfoAdd';
  static const String _receivingInfoUpdate = '${Server.receivingInfo}/receivingInfoUpdate';
  static const String _receivingInfoDelete = '${Server.receivingInfo}/receivingInfoDelete';

  static Future<ResultEntity<List<ReceivingInfo>>> getReceivingInfos() async {
    try {
      Response response = await HttpUtils.get(_receivingInfo,
          // params: {'uid': UserAPI.user!.uid},
          options: Options(headers: {'Token': UserAPI.token}));
      if(!response.valid){
        return ResultEntity.error();
      }
      List<ReceivingInfo> list = [];
      var data = response.data['data'];
      for (var item in data) {
        list.add(ReceivingInfo.fromJson(item));
      }
      return ResultEntity.succeed(data: list);
    } catch (e) {
      return ResultEntity.error();
    }
  }

  static Future<ResultEntity<ReceivingInfo>> getReceivingInfoDetail(int id) async {
    try {
      Response response = await HttpUtils.get(_receivingInfoDetail,
          params: {'id': id},
          options: Options(headers: {'Token': UserAPI.token}));
      if(!response.valid){
        return ResultEntity.error();
      }
      return ResultEntity.succeed(data: ReceivingInfo.fromJson(response.data['data']));
    } catch (e) {
      return ResultEntity.error();
    }
  }

  static Future<ResultEntity> receivingInfoAdd(ReceivingInfo receivingInfo) async {
    try {
      Response response = await HttpUtils.post(_receivingInfoAdd,
          data: {'receivingInfoJson': jsonEncode(receivingInfo.toJson())},
          options: Options(headers: {'Token': UserAPI.token}));
      if(!response.valid){
        return ResultEntity.error();
      }
      return ResultEntity.succeed();
    } catch (e) {
      return ResultEntity.error();
    }
  }

  static Future<ResultEntity> receivingInfoUpdate(ReceivingInfo receivingInfo) async {
    try {
      Response response = await HttpUtils.post(_receivingInfoUpdate,
          data: {'receivingInfoJson': jsonEncode(receivingInfo.toJson())},
          options: Options(headers: {'Token': UserAPI.token}));
      if(!response.valid){
        return ResultEntity.error();
      }
      return ResultEntity.succeed();
    } catch (e) {
      return ResultEntity.error();
    }
  }

  static Future<ResultEntity> receivingInfoDelete(int id) async {
    try {
      Response response = await HttpUtils.post(_receivingInfoDelete,
          data: {'id': id},
          options: Options(headers: {'Token': UserAPI.token}));
      if(!response.valid){
        return ResultEntity.error();
      }
      return ResultEntity.succeed();
    } catch (e) {
      return ResultEntity.error();
    }
  }


}