import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../entity/wss_entity.dart';

typedef WssListener = void Function(dynamic data);

class WssAPI {
  static final wsUrl = Uri.parse('wss://handfisher.uk/world_first/websocket');
  final String _verifyApi = 'verify';
  final String _pingApi = 'ping';
  static WssAPI? _instance;
  late WebSocketChannel _channel;
  final Map<String, List<StreamController>> _controllers = {};
  final Map<String, Completer<WssResult>> _requests = {};
  Timer? pingTimer;

  WssAPI._() {
    _initialize();
  }

  factory WssAPI() {
    _instance ??= WssAPI._();
    return _instance!;
  }

  Future<void> _initialize() async {
    pingTimer?.cancel();
    _channel = WebSocketChannel.connect(wsUrl);
    await _verify();
    pingTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      ping();
    });
    _channel.stream.listen((data) {
      if (kDebugMode) {
        print(data);
      }
      Map<String, dynamic> jsonMap = jsonDecode(data);
      if (jsonMap.containsKey('requestId')) {
        String requestId = jsonMap['requestId'];
        if (_requests.containsKey(requestId)) {
          Completer completer = _requests.remove(requestId)!;
          var result = WssResult(
              api: jsonMap['api'],
              code: jsonMap['code'],
              message: jsonMap['message'],
              data: jsonMap['data']);
          completer.complete(result);
        }
      }
      String api = jsonMap['api'];
      //遍历外部添加的controller
      if (_controllers.containsKey(api)) {
        for (var controller in _controllers[api]!) {
          if (controller.isClosed) {
            _controllers[api]!.remove(controller);
          } else {
            controller.add(jsonMap['data']);
          }
        }
      }
    });
  }

  Future<void> _verify() async {
    await send(api: _verifyApi, params: {
      // 'token': UserAPI.token,
    });
  }

  Future<void> ping() async {
    WssRequest request = WssRequest(api: _pingApi, requestId: genRequestId);
    _channel.sink.add(jsonEncode(request));
  }

  Future<WssResult> send(
      {required String api,
        bool needWait = false,
        Map<String, dynamic> params = const {}}) async {
    if (_channel.closeCode != null) {
      await _initialize();
    }
    String requestId = genRequestId;
    if (needWait) {
      _requests[requestId] = Completer();
    }
    WssRequest request =
    WssRequest(api: api, requestId: requestId, params: params);
    String data = jsonEncode(request);
    _channel.sink.add(data);
    if (needWait) {
      return _requests[requestId]!.future;
    } else {
      return WssResult.empty(api: api);
    }
  }

  void registerApiController(String api, StreamController controller) {
    if (!_controllers.containsKey(api)) {
      _controllers[api] = [controller];
    } else {
      _controllers[api]!.add(controller);
    }
  }

  void removeApiController(StreamController controller) {
    for (var entry in _controllers.entries) {
      if (entry.value.contains(controller)) {
        entry.value.remove(controller);
      }
    }
  }

  void dispose() {
    pingTimer?.cancel();
    //释放资源
    for (var entry in _controllers.entries) {
      for (var element in entry.value) {
        element.close();
      }
    }
    _controllers.clear();
    _channel.sink.close();
  }

  String get genRequestId {
    Random random = Random();
    return random.nextInt(10000).toString();
  }
}
