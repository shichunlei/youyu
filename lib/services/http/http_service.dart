import 'dart:io';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/services/http/http_manager.dart';
import 'package:youyu/utils/log_utils.dart';
import 'package:youyu/utils/sign_utils.dart';
import 'package:youyu/utils/uuid_utils.dart';
import 'package:youyu/utils/version_utils.dart';
import 'package:youyu/config/config.dart';
import 'package:youyu/controllers/app_controller.dart';
import 'package:youyu/controllers/auth_controller.dart';
import 'package:dio/dio.dart';
import 'package:youyu/utils/platform_utils.dart';

///请求服务
class HttpService extends AppBaseController {
  static HttpService? _instance;

  factory HttpService() => _instance ??= HttpService._();

  HttpService._();

  initHttp() async {
    String version = await VersionUtils.getVersionCode();
    String userAgent = "app/$version";
    if (PlatformUtils.isAndroid) {
      userAgent += "/android";
    } else if (PlatformUtils.isIOS) {
      userAgent += "/ios";
    }
    HttpManager().lazyInit(
        options: BaseOptions(
          baseUrl: AppConfig.baseUrl,
          headers: {
            "content-type": "application/json",
            HttpHeaders.userAgentHeader: userAgent
          },
          //连接服务器超时时间，单位是毫秒.
          connectTimeout: const Duration(seconds: 10),
          //响应流上前后两次接受到数据的间隔，单位为毫秒。
          receiveTimeout: const Duration(seconds: 10),
          validateStatus: (statusCode) {
            final codes = [100, 200, 400, 405, 500];
            return codes.contains(statusCode);
          },
          //表示期望以那种格式(方式)接受响应数据。接受四种类型 `  json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
          responseType: ResponseType.json,
        ),
        onRequest: (options, handler) async {
          RequestOptions interceptorOption =
              await _RequestInterceptor.requestInterceptor(options);
          return handler.next(interceptorOption);
        },
        onResponse: (options, handler) async {
          return handler
              .next(_ResponseInterceptor.responseInterceptor(options));
        });
  }
}

///请求拦截器
class _RequestInterceptor {
  /// 公共的header 、get 、post
  static Future<RequestOptions> requestInterceptor(
      RequestOptions options) async {
    // 获取版本号信息
    String version = "";
    if (AppController.to.version.isNotEmpty) {
      version = AppController.to.version;
    } else {
      version = await VersionUtils.getVersionCode();
    }
    //获取构建版本号
    String buildNumber = "";
    if (AppController.to.buildNumber.isNotEmpty) {
      buildNumber = AppController.to.buildNumber;
    } else {
      buildNumber = await VersionUtils.getBuildCode();
    }
    // 获取设备ID
    String deviceId = "";
    if (AppController.to.deviceId.isNotEmpty) {
      deviceId = AppController.to.deviceId;
    } else {
      deviceId = await DeviceUtils.getDeviceId();
    }
    // 生成32位随机字符串
    String randomText = SignUtil().getRandomString();
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    // 生成签名
    String sign = SignUtil().getSignString(randomText, timestamp);
    // 添加请求头
    options.headers.addAll({
      'app-version': '$version+$buildNumber',
      'device': deviceId,
      'timestamp': timestamp,
      'chars': randomText,
      'sign': sign,
    });

    // 检查是否有Token 如果有就加入header
    if (AuthController.to.token.isNotEmpty) {
      options.headers.addAll({
        'token': AuthController.to.token,
      });
    }

    _printRequestLog(options);

    return options;
  }

  //打印请求
  static _printRequestLog(RequestOptions options) {
    bool isPrintLog = options.extra.containsKey("isPrintLog")
        ? options.extra['isPrintLog']
        : false;
    isPrintLog = true;
    if (isPrintLog) {
      if (options.method == "GET") {
        LogUtils.onInfo(
            '================> Request(GET): ${options.path} \n header:${options.headers.toString()} \n params:${options.queryParameters.toString()}\n');
      } else {
        if (options.data is FormData) {
          LogUtils.onInfo(
              '================> Request(POST): ${options.path} \n header:${options.headers.toString()}  \n params:${(options.data as FormData).fields.toString()}\n');
        } else {
          LogUtils.onInfo(
              '================> Request(POST): ${options.path} \n header:${options.headers.toString()}  \n params:${options.data.toString()}\n');
        }
      }
    }
  }
}

///响应拦截器
class _ResponseInterceptor {
  static Response responseInterceptor(Response response) {
    _printResponseLog(response);
    return response;
  }

  //打印结果
  static _printResponseLog(Response response) {
    bool isPrintLog = response.requestOptions.extra.containsKey("isPrintLog")
        ? response.requestOptions.extra['isPrintLog']
        : false;
    isPrintLog = true;
    bool isPrint = false;
    isPrint = true;
    if (isPrint && isPrintLog) {
      if (response.requestOptions.method == "GET") {
        LogUtils.onInfo(
            '================> Response(GET): ${response.requestOptions.path} \n result:${response.data}\n');
      } else {
        LogUtils.onInfo(
            '================> Response(POST): ${response.requestOptions.path} \n result:${response.data}\n');
      }
    }
  }
}
