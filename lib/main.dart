
import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_commerce/route/route.dart';
import 'package:live_video_commerce/ui/page/home_page.dart';
import 'package:live_video_commerce/utils/constant_string_utils.dart';
import 'package:live_video_commerce/utils/http_utils.dart';
import 'package:live_video_commerce/utils/store_utils.dart';
import 'package:media_kit/media_kit.dart';

import 'api/server.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    MediaKit.ensureInitialized();
    HttpUtils.config(baseUrl: Server.baseUrl);
    await Store.initialize();
    runApp(const MyApp());
  }, (Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      print(error);
      print(stackTrace);
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme? mcolorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
    return GetMaterialApp(
      title: ConstantStringUtils.appTitle,
      builder: BotToastInit(),
      theme: ThemeData(
        colorScheme: mcolorScheme,
        useMaterial3: true,
      ),
      onGenerateRoute: RouteTable.generateRoute,
      home: const HomePage(),
    );
  }
}

