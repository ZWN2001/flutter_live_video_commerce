import 'package:dio/dio.dart';

class Server {
  static const String host = "http://$hostIp:8081";
  static const String hostIp = "10.10.10.73";
  static const String baseUrl = host;
  // static const String wsServer = 'wss://---/wss/';

  static const String user = "/users";
  static const String live = "/liveRoom";
  static const String commodity = "/commodity";
  static const String receivingInfo = "/receivingInfo";


}

extension ResponseExtension on Response {
  bool get valid {
    return data != null && data['code'] == 200;
  }
}