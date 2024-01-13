
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:live_video_commerce/route/route.dart';
import 'package:live_video_commerce/utils/constant_string_utils.dart';
import 'package:live_video_commerce/utils/http_utils.dart';

import 'api/server.dart';

void main(){
  HttpUtils.config(baseUrl: Server.baseUrl);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme? mcolorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
    return MaterialApp.router(
      title: ConstantStringUtils.appTitle,
      builder: BotToastInit(),
      theme: ThemeData(
        colorScheme: mcolorScheme,
        useMaterial3: true,
      ),
      routerConfig: Routes.routers,
    );
  }
}

