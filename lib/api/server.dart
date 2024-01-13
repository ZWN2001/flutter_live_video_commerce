import 'package:dio/dio.dart';

class Server {
  static const String host = "---";
  static const String baseUrl = '$host/live';
  static const String wsServer = 'wss://---/wss/';

  static const String auth = "/auth";
  static const String user = "/auth/user";
  static const String live = "/live";
  static const String commerce = "/commerce";


}

extension ResponseExtension on Response {
  bool get valid {
    return data != null && data['code'] == 0;
  }
}