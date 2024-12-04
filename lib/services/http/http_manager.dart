import 'package:youyu/services/http/http_error.dart';
import 'package:youyu/utils/log_utils.dart';
import 'package:youyu/utils/toast_utils.dart';
import 'package:dio/dio.dart';

enum HttpMethod { post, get }

class HttpManager {
  static HttpManager? _instance;

  factory HttpManager() => _instance ??= HttpManager._();

  HttpManager._();

  /// HttpManager是否初始化
  static bool _isInit = false;

  static const String _errorText = 'Http Uninitialized';

  late Dio _dio;

  /// HTTP初始化 + 拦截器
  lazyInit({
    required BaseOptions options,
    void Function(RequestOptions, RequestInterceptorHandler)? onRequest,
    void Function(Response<dynamic>, ResponseInterceptorHandler)? onResponse,
    void Function(DioException, ErrorInterceptorHandler)? onError,
  }) {
    _isInit = true;
    _dio = Dio(options);
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: onRequest,
        onResponse: onResponse,
        onError: onError,
      ),
    );
    /*
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
    };
     */
  }

  ///获取userAgent
  String getDefaultUserAgent() {
    return _dio.options.headers['user-agent'];
  }

  /// get请求
  Future<String> get(
    String path, {
    Options? options,
    bool isShowToast = true,
    CancelToken? cancelToken,
    bool? isPrintLog,
    Map<String, dynamic>? params,
  }) async {
    if (!_isInit) {
      ToastUtils.show(_errorText);
      throw HttpErrorException(errorType: HttpErrorType.other);
    }
    try {
      if (options == null) {
        options = Options();
        options.extra = {"isPrintLog": (isPrintLog ?? false)};
      } else {
        options.extra = {"isPrintLog": (isPrintLog ?? false)};
      }
      final response = await _dio.get<String>(
        path,
        options: options,
        queryParameters: params,
        cancelToken: cancelToken,
      );
      final result = response.data ?? "";
      return result;
    } catch (e) {
      LogUtils.onError('===================> Error(NET GET): $path \n e:$e\n\n',
          tag: "http");
      String errorMessage = "网络链接失败";

      if (e is DioException) {
        if (e.type != DioExceptionType.cancel) {
          errorMessage += "\n错误类型: ${e.type}";
          errorMessage += "\n错误信息: ${e.message}";

          if (isShowToast) {
            ToastUtils.show("$path\n$errorMessage");
          }

          throw HttpErrorException(
              errorType: HttpErrorType.web, dioException: e);
        }
      } else {
        errorMessage += "\n错误信息: ${e.toString()}";

        if (isShowToast) {
          ToastUtils.show("$path\n$errorMessage");
        }

        throw HttpErrorException(errorType: HttpErrorType.web);
      }

      throw HttpErrorException(errorType: HttpErrorType.web);
    }
  }

  /// post请求
  Future<String> post(
    String path, {
    Options? options,
    bool isShowToast = true,
    CancelToken? cancelToken,
    bool? isPrintLog,
    Map<String, dynamic>? data,
  }) async {
    if (!_isInit) {
      ToastUtils.show(_errorText);
      throw HttpErrorException(errorType: HttpErrorType.other);
    }

    try {
      if (options == null) {
        options = Options();
        options.extra = {"isPrintLog": (isPrintLog ?? false)};
      } else {
        options.extra = {"isPrintLog": (isPrintLog ?? false)};
      }
      final response = await _dio.post<String>(
        path,
        data: data,
        options: options,
        cancelToken: cancelToken,
      );

      final result = response.data ?? "";

      return result;
    } catch (e) {
      LogUtils.onError('===================> Error(NET POST): $path \n e:$e\n',
          tag: "http");
      String errorMessage = "网络链接失败";

      if (e is DioException) {
        if (e.type != DioExceptionType.cancel) {
          errorMessage += "\n错误类型: ${e.type}";
          errorMessage += "\n错误信息: ${e.message}";

          if (isShowToast) {
            ToastUtils.show("$path\n$errorMessage");
          }

          throw HttpErrorException(
              errorType: HttpErrorType.web, dioException: e);
        }
      } else {
        errorMessage += "\n错误信息: ${e.toString()}";

        if (isShowToast) {
          ToastUtils.show("$path\n$errorMessage");
        }

        throw HttpErrorException(errorType: HttpErrorType.web);
      }

      throw HttpErrorException(errorType: HttpErrorType.web);
    }
  }

  /// upload上传
  Future<String> upload(
    String path, {
    dynamic data,
    Options? options,
    bool isShowToast = true,
    bool? isPrintLog,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
  }) async {
    if (!_isInit) {
      ToastUtils.show(_errorText);
      throw HttpErrorException(errorType: HttpErrorType.other);
    }
    try {
      if (options == null) {
        options = Options();
        options.extra = {"isPrintLog": (isPrintLog ?? false)};
      } else {
        options.extra = {"isPrintLog": (isPrintLog ?? false)};
      }
      final response = await _dio.post<String>(
        path,
        data: data,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );

      final result = response.data ?? "";
      return result;
    } catch (e) {
      LogUtils.onError(
          '===================> Error(NET Upload): $path \n e:$e\n',
          tag: "http");
      String errorMessage = "网络链接失败";

      if (e is DioException) {
        if (e.type != DioExceptionType.cancel) {
          errorMessage += "\n错误类型: ${e.type}";
          errorMessage += "\n错误信息: ${e.message}";

          if (isShowToast) {
            ToastUtils.show("$path\n$errorMessage");
          }

          throw HttpErrorException(
              errorType: HttpErrorType.web, dioException: e);
        }
      } else {
        errorMessage += "\n错误信息: ${e.toString()}";

        if (isShowToast) {
          ToastUtils.show("$path\n$errorMessage");
        }

        throw HttpErrorException(errorType: HttpErrorType.web);
      }

      throw HttpErrorException(errorType: HttpErrorType.web);
    }
  }

  /// 文件下载
  Future<bool> download(
    String urlPath,
    String savePath, {
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    final response = await _dio.download(
      urlPath,
      savePath,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
    return response.statusCode == 200;
  }
}
