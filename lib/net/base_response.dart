class BaseResponse<T> {
  final int code;
  final String msg;
  final T? data;
  final String requestId;

  BaseResponse({
    required this.code,
    required this.msg,
    this.data,
    required this.requestId,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
    return BaseResponse<T>(
      code: json['code'] as int,
      msg: json['msg'] as String,
      data: json['data'] == null ? null : fromJsonT(json['data']),
      requestId: json['requestId'] as String,
    );
  }
}
