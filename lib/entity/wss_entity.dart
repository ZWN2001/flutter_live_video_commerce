class WssRequest {
  final String api;
  final String requestId;
  final Map<String, dynamic> params;

  const WssRequest({
    required this.api,
    required this.requestId,
    this.params = const {},
  });

  Map<String, dynamic> toJson() => {
    'api': api,
    'requestId': requestId,
    'params': params,
  };
}

class WssResult<T> {
  final String api;
  final int code;
  final String message;
  final T? data;

  const WssResult({
    required this.api,
    required this.code,
    required this.message,
    this.data,
  });

  const WssResult.empty({
    required this.api,
  })  : code = 0,
        message = '',
        data = null;
}
