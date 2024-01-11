
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:live_video_commerce/route/route.dart';
import 'package:live_video_commerce/ui/page/home_page.dart';
import 'package:live_video_commerce/utils/constant_string_utils.dart';

void main() => runApp(const MyApp());

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
      routes: Routes.routers,
      home: const HomePage(),
    );
  }
}

