import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../ui/page/home_page.dart';
import '../ui/page/login_page.dart';

class Routes {
  static const String root = '/';
  static const String chat = 'chat';
  static const String home = 'home';
  static const String login = 'login';
  static const String postDetail = 'post_detail';
  static const String post = 'post';

  static final _routers = GoRouter(
    navigatorKey: Get.key,
    observers: [BotToastNavigatorObserver(), GetObserver()],
    routes: [
      GoRoute(
          name: root,
          path: '/',
          redirect: _loginRedirect,
          builder: (context, state) {
            return const HomePage();
          },
          routes: [
            // GoRoute(
            //   name: post,
            //   path: 'post',
            //   builder: (context, state) {
            //     String? postId = state.uri.queryParameters['id'];
            //     return PostJumpPage(postId: int.parse(postId ?? '-1'));
            //   },
            // ),
            // GoRoute(
            //   name: postDetail,
            //   path: 'post_detail',
            //   builder: (context, state) {
            //     Post post = state.extra! as Post;
            //     return PostDetailPage(post: post);
            //   },
            // ),
          ]),
      GoRoute(
        name: login,
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        name: home,
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
    ],
  );

  static get routers => _routers;

  static String? _loginRedirect(context, state) {
    // return UserStatus.isLogin ? null : '/login';
    return null;
  }
}
