import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:go_router/go_router.dart';

import '../../entity/result.dart';
import '../../route/route.dart';
import '../../utils/constant_string_utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  void initState() {
    super.initState();
  }

  Future<String?> _authUser(LoginData data) async {
    // var result =
    // await UserAPI.login(username: data.name, password: data.password);
    // if (result.success) {
      return null;
    // } else {
    //   return result.message;
    // }
  }

  Future<String?> _signupUser(SignupData data) async {
    // ResultEntity result = await UserAPI.register(
    //   username: data.name ?? '',
    //   password: data.password ?? '',
    // );
    // if (result.success) {
      return null;
    // }
    // return result.message;
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      logo: 'assets/images/logo.png',
      title: ConstantStringUtils.appTitle,
      theme: LoginTheme(
        pageColorDark: Colors.green,
        pageColorLight: Colors.lightBlue,
        titleStyle: const TextStyle(
          color: Colors.white,
        ),
      ),
      hideForgotPasswordButton: true,
      messages: LoginMessages(
          userHint: '手机号',
          passwordHint: '密码',
          confirmPasswordHint: '确认密码',
          confirmPasswordError: '两次输入的密码不一致',
          loginButton: '登录',
          signupButton: '注册',
          forgotPasswordButton: '找回密码',
          goBackButton: '返回',
          flushbarTitleError: '错误',
          flushbarTitleSuccess: '成功',
          additionalSignUpSubmitButton: '注册',
          recoverPasswordButton: '恢复',
          recoverCodePasswordDescription: '请注意保护好您的个人信息',
          recoverPasswordDescription: '请输入您的手机号',
          recoverPasswordIntro: '找回密码',
          setPasswordButton: '设置密码'),
      userType: LoginUserType.phone,
      confirmSignupRequired: (_) async => false,
      loginAfterSignUp: true,
      onResendCode: (data) {
        return null;
      },
      userValidator: (String? username) {
        return null;
      },
      passwordValidator: (String? password) {
        if (password == null || password.length < 6) {
          return '密码太短';
        }
        return null;
      },
      onLogin: _authUser,
      onSubmitAnimationCompleted: () {
        context.goNamed(Routes.home);
      },
      onConfirmRecover: (a, b) {
        return null;
      },
      onRecoverPassword: (String a) {
        return null;
      },
      onSignup: _signupUser,
    );
  }
}
