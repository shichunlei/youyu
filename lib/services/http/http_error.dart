import 'package:youyu/services/http/http_response.dart';
import 'package:dio/dio.dart';

enum HttpErrorType { business, web, json, other }

class HttpErrorException implements Exception {
  HttpErrorException(
      {required this.errorType,
      this.code = 1,
      this.response,
      this.msg,
      this.dioException});

  //失败类型
  final HttpErrorType errorType;

  //状态码
  final int code;

  //内容
  final HttpResponse? response;

  //文案
  final String? msg;

  //dio异常(外层应该很少用到)
  final DioException? dioException;
}
