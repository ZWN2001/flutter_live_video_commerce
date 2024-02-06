import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
import 'package:live_video_commerce/state/user_status.dart';
import 'package:live_video_commerce/ui/page/user/shopping_cart_page.dart';

import '../ui/page/home_page.dart';
import '../ui/page/functions_page/login_page.dart';
import '../ui/page/special/special_page.dart';

// class Routes {
//   static const String root = '/';
//   static const String chat = 'chat';
//   static const String home = 'home';
//   static const String login = 'login';
//   static const String postDetail = 'post_detail';
//   static const String post = 'post';
//
//   static final _routers = GoRouter(
//     navigatorKey: Get.key,
//     observers: [BotToastNavigatorObserver(), GetObserver()],
//     routes: [
//       GoRoute(
//           name: root,
//           path: '/',
//           redirect: _loginRedirect,
//           builder: (context, state) {
//             return const HomePage();
//           },
//           routes: [
//             // GoRoute(
//             //   name: post,
//             //   path: 'post',
//             //   builder: (context, state) {
//             //     String? postId = state.uri.queryParameters['id'];
//             //     return PostJumpPage(postId: int.parse(postId ?? '-1'));
//             //   },
//             // ),
//             // GoRoute(
//             //   name: postDetail,
//             //   path: 'post_detail',
//             //   builder: (context, state) {
//             //     Post post = state.extra! as Post;
//             //     return PostDetailPage(post: post);
//             //   },
//             // ),
//           ]),
//       GoRoute(
//         name: login,
//         path: '/login',
//         builder: (context, state) => const LoginPage(),
//       ),
//       GoRoute(
//         name: home,
//         path: '/home',
//         builder: (context, state) => const HomePage(),
//       ),
//     ],
//   );
//
//   static get routers => _routers;
//
//   static String? _loginRedirect(context, state) {
//     // return UserStatus.isLogin ? null : '/login';
//     return null;
//   }
// }

class RouteTable {
  static const String root = '/';
  static const String home = 'home';
  static const String login = 'login';
  static const String shoppingCart = 'shoppingCart';

  static final Map<String, WidgetBuilder> _routes = {
    root: (context) => const HomePage(),
    login: (context) => const LoginPage(),
    home: (context) => const HomePage(),
    shoppingCart: (context) => const ShoppingCartPage(),
  };

  static final Map<String, bool> _needLogin = {
    root: false,
    login: false,
    home: false,
    shoppingCart: true,
  };

  static Route generateRoute(RouteSettings settings) {
    // 路由名称未出现在路由表里,返回空界面
    if (!_routes.containsKey(settings.name)) {
      return MaterialPageRoute(
          builder: (_) => NotFoundPage(settings: settings));
    }
    if (!UserStatus.isLogin &&
        settings.name != null &&
        (_needLogin[settings.name] ?? false)) {
      return MaterialPageRoute(
          builder: (context) => const LoginPage(), settings: settings);
    }
    return MaterialPageRoute(
        builder: _routes[settings.name]!, settings: settings);
  }
}


