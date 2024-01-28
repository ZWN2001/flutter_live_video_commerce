import 'package:flutter/material.dart';

class ForbiddenPage extends StatelessWidget {
  final RouteSettings settings;
  const ForbiddenPage({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('无权访问'),
      ),
      body: const Center(
        child: Text('您无权访问此页面'),
      ),
    );
  }
}

class NotFoundPage extends StatelessWidget {
  final RouteSettings settings;

  const NotFoundPage({Key? key, required this.settings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('页面不存在'),
      ),
      body: Center(
        child: Text('该页面不存在: ${settings.name}'),
      ),
    );
  }
}

class PlatformNotSupportPage extends StatelessWidget {
  final RouteSettings settings;

  const PlatformNotSupportPage({Key? key, required this.settings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('暂不支持'),
      ),
      body: Center(
        child: Text('该平台不支持内嵌此页面: ${settings.name}'),
      ),
    );
  }
}
