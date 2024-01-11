///状态码Status Code
enum SC {
  success(0, '请求成功'),

  ///服务器错误
  serverError(-1, '服务器错误'),

  ///未知错误
  unknownError(-10001, '未知错误'),

  ///客户端错误
  deviceError(-10002, '客户端错误'),

  ///用户取消操作
  userCancel(-10003, '用户取消'),

  ///无操作
  noOperation(-10004, '无操作'),

  ///超时
  timeout(-10005, '超时'),

  /// 参数范围或格式错误
  paramWrong(40000, "参数范围或格式错误"),

  /// 网络错误
  networkWrong(40001, "网络错误"),

  /// 当前条件或时间不允许
  requestNotAllowed(40002, "当前条件或时间不允许〒▽〒"),

  /// 请求繁忙，请稍后再试
  requestFrequently(40003, "请求繁忙，请稍后再试"),

  /// 内容不存在
  contentNotFound(40004, "你要找的东西好像走丢啦X﹏X"),

  /// 方法不允许
  methodNotAllowed(40005, "方法不允许"),

  /// 这是最后一页，再怎么找也没有啦
  thisIsLastPage(40006, "这是最后一页，再怎么找也没有啦"),

  /// 没有上一页啦
  thisIsFirstPage(40007, "没有上一页啦"),

  /// 图片格式只能为jpg, jpeg, png, gif, bmp, webp
  picFormatError(40008, "图片格式只能为jpg, jpeg, png, gif, bmp, webp"),

  /// 用户凭证不存在
  cookieNotFound(40009, "用户凭证不存在"),

  /// 用户不存在
  userNotExist(40200, "用户不存在"),

  /// 头像上传失败
  picUploadFail(40201, "头像上传失败"),


  /// 登录状态已失效
  loginStatusIsInvalid(40101, "登录已过期,请退出重新登录"),

  /// 登录状态错误，请重新登录
  refreshTokenWrong(40102, "登录已过期,请退出重新登录"),

  /// 无权限
  permNotAllow(40103, "无权限"),

  /// 当前请求过多，请稍后再试
  networkCongestion(40106, "当前请求过多，请稍后再试"),

  /// 板块不存在
  sectionNotExist(40500, "该板块不存在"),

  /// 用户已被封禁
  userViolation(40509, "用户已被封禁"),

  /// 验证失败
  verifyFailed(40510, "验证失败");

  const SC(this.code, this.reason);

  final String reason;
  final int code;
}

class ResultEntity<T> {
  static final Map<int, SC> _scMap = {};
  final bool success;
  final SC code;
  final String message;
  final T? data;

  ///成功实体
  ///[code]状态信息
  ///[message] 默认为code中的reason信息,提供后会覆写code中包含的reason信息
  ///[data] 请求实体的返回值
  factory ResultEntity.succeed(
      {SC code = SC.success, String? message, T? data}) {
    message ??= SC.success.reason;
    return ResultEntity._(
        success: true, code: code, message: message, data: data);
  }

  ///失败实体
  ///[code]状态信息
  ///[message] 默认为code中的reason信息,提供后会覆写code中包含的reason信息
  ///[data] 请求实体的返回值
  factory ResultEntity.error(
      {SC code = SC.serverError, String? message, T? data}) {
    message ??= SC.serverError.reason;
    return ResultEntity._(
        success: false, code: code, message: message, data: data);
  }

  ///用户取消
  ///[message] 默认为code中的reason信息,提供后会覆写code中包含的reason信息
  ///[data] 请求实体的返回值
  factory ResultEntity.cancel({String? message, T? data}) {
    message ??= SC.userCancel.reason;
    return ResultEntity._(
        success: false, code: SC.userCancel, message: message, data: data);
  }

  ///无操作
  ///[message] 默认为code中的reason信息,提供后会覆写code中包含的reason信息
  ///[data] 请求实体的返回值
  factory ResultEntity.nop({String? message, T? data}) {
    message ??= SC.noOperation.reason;
    return ResultEntity._(
        success: false, code: SC.userCancel, message: message, data: data);
  }

  ///无操作
  ///[message] 默认为code中的reason信息,提供后会覆写code中包含的reason信息
  ///[data] 请求实体的返回值
  factory ResultEntity.fromSC(SC sc, {T? data}) {
    return ResultEntity._(
        success: false, code: sc, message: sc.reason, data: data);
  }

  ///失败实体
  ///[code]状态信息
  ///[data] 请求实体的返回值
  factory ResultEntity.timeout({SC code = SC.timeout, T? data}) {
    return ResultEntity._(
        success: false, code: code, message: '请求超时', data: data);
  }

  ///用户取消
  ///[code]对应[SC]中的[SC.code]信息,通过该code生成SC,不存在在该code则返回[SC.UNKNOWN_ERROR]
  ///[message] 默认为code中的reason信息,提供后会覆写code中包含的reason信息
  ///[data] 请求实体的返回值
  factory ResultEntity.fromCode({int? code, String? message, T? data}) {
    if (_scMap.isEmpty) {
      for (var sc in SC.values) {
        _scMap[sc.code] = sc;
      }
    }
    if (code == null) {
      return ResultEntity.error(
        code: SC.unknownError,
        message: message ?? SC.unknownError.reason,
        data: data,
      );
    } else if (code == 0) {
      return ResultEntity.succeed(
        code: SC.success,
        message: message ?? SC.success.reason,
        data: data,
      );
    } else {
      SC statusCode =
          _scMap.containsKey(code) ? _scMap[code]! : SC.unknownError;
      return ResultEntity.error(
        code: statusCode,
        message: message ?? statusCode.reason,
        data: data,
      );
    }
  }

  const ResultEntity._(
      {required this.success,
      required this.code,
      required this.message,
      this.data});

  ResultEntity copyWith({
    bool? result,
    SC? code,
    String? message,
    T? data,
    SC? statusCode,
  }) {
    return ResultEntity._(
      success: result ?? this.success,
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  @override
  String toString() {
    return 'ResultEntity{success: $success, code: $code, message: $message, data: $data}';
  }
}

class WSSEntity<T> {
  String api;
  String requestId;
  Map<String, dynamic> params;
  T data;

  WSSEntity({
    required this.api,
    required this.requestId,
    required this.params,
    required this.data,
  });
}
