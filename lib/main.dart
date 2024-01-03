
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:live_video_commerce/ui/home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme? mcolorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
    return MaterialApp(
      title: '带货直播机',
      builder: BotToastInit(),
      theme: ThemeData(
        colorScheme: mcolorScheme,
        useMaterial3: true,
      ),
      home: const HomePage( ),
    );
  }
}

