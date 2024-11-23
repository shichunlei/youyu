class HttpResponse<T> {
  HttpResponse({required this.code, this.msg, this.data});

  final int code; //1成功
  final T? data;
  final String? msg;

  factory HttpResponse.fromJson(Map<String, dynamic> json) => HttpResponse(
        msg: json['msg'],
        data: json['data'],
        code: json['code'] ?? 1,
      );
}
