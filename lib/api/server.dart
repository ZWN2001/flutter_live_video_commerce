import 'package:dio/dio.dart';

class Server {
  static const String host = "http://192.168.43.238:8081";
  static const String baseUrl = host;
  // static const String wsServer = 'wss://---/wss/';

  static const String user = "/users";
  static const String live = "/live";
  static const String commodity = "/commodity";


}

extension ResponseExtension on Response {
  bool get valid {
    return data != null && data['code'] == 200;
  }
}