import 'dart:async';
import 'dart:convert';
import 'package:youyu/config/api.dart';
import 'package:youyu/services/http/http_error.dart';
import 'package:youyu/services/http/http_manager.dart';
import 'package:youyu/services/http/http_response.dart';
import 'package:youyu/utils/log_utils.dart';
import 'package:youyu/utils/toast_utils.dart';
import 'package:youyu/widgets/app/app_default.dart';
import 'package:youyu/widgets/app/app_progress.dart';
import 'package:dio/dio.dart' as base_dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../auth_controller.dart';

enum GetxIds {
  /// loading Id
  loading,

  /// 页面id
  page,
}

class PageConfig {
  //分页开始 从1开始
  static const int start = 1;

  //分页20条
  static const int limit = 20;

  //大分页100条
  static const int maxLimit = 100;
}

abstract class AppBaseController extends FullLifeCycleController
    with FullLifeCycleMixin {
  ///上下文
  BuildContext? get buildContext {
    return Get.context;
  }

  /// 组件加载状态
  AppLoadType loadType = AppLoadType.success;

  ///是否显示loading
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set setIsLoading(bool value) {
    _isLoading = value;
    update([GetxIds.loading]);
  }

  ///是否空数据(列表试图使用 )
  bool isNoData = false;

  /// 控制器是否注销
  bool _mounted = true;

  bool get mounted => _mounted;

  ///是否在登录主页 (兼容一键登录)
  bool _isLoginIndex = false;

  bool get isLoginIndex => _isLoginIndex;

  set setIsLoginIndex(bool value) {
    _isLoginIndex = value;
  }

  ///下拉刷新
  RefreshController refreshController = RefreshController();

  ///默认页面配置
  AppDefaultConfig? pageDefaultConfig;

  ///取消请求
  final List<base_dio.CancelToken> _cancelTokens = [];

  /////////////////////////////////////////////////////////////////////////////////
  //
  //                      页面刷新
  //
  /////////////////////////////////////////////////////////////////////////////////

  /// 设置组件加载类型
  void _setLoadType(AppLoadType type, [List<Object>? ids]) {
    loadType = type;
    if (ids != null) {
      update([...ids]);
    } else {
      update();
    }
  }

  ///无
  void setNoneType() {
    _setLoadType(AppLoadType.none, [GetxIds.page]);
  }

  ///页面成功
  void setSuccessType({bool hiddenPageLoading = true}) {
    if (hiddenPageLoading) {
      setIsLoading = false;
    }
    _setLoadType(AppLoadType.success, [GetxIds.page]);
  }

  /// 空白页面
  void setEmptyType(
      {String? message,
      bool hiddenPageLoading = true,
      AppDefaultConfig? defaultConfig}) {
    if (hiddenPageLoading) {
      setIsLoading = false;
    }
    loadType = AppLoadType.empty;
    pageDefaultConfig =
        defaultConfig ?? AppDefaultConfig.defaultConfig(loadType, msg: message);
    update([GetxIds.page]);
  }

  /// 页面失败
  void setErrorType(var e,
      {bool hiddenPageLoading = true, AppDefaultConfig? defaultConfig}) {
    if (hiddenPageLoading) {
      setIsLoading = false;
    }
    String? msg;
    if (e is HttpErrorException) {
      msg = e.msg;
    }
    loadType = AppLoadType.error;
    pageDefaultConfig =
        defaultConfig ?? AppDefaultConfig.defaultConfig(loadType, msg: msg);
    update([GetxIds.page]);
  }

  /////////////////////////////////////////////////////////////////////////////////
  //
  //                      网络请求
  //
  /////////////////////////////////////////////////////////////////////////////////

  ///公用网络请求
  Future<HttpResponse> request(String path,
      {base_dio.Options? options,
      bool isShowToast = true,
      HttpMethod method = HttpMethod.post,
      bool isHiddenCommitLoading = true,
      bool isPrintLog = true,
      bool isCancelByLeave = true,
      Map<String, dynamic>? params}) async {
    base_dio.CancelToken? cancelToken;
    if (isCancelByLeave) {
      cancelToken = base_dio.CancelToken();
      _cancelTokens.add(cancelToken);
    }
    if (method == HttpMethod.get) {
      return HttpManager()
          .get(path,
              isShowToast: isShowToast,
              options: options,
              isPrintLog: isPrintLog,
              cancelToken: cancelToken,
              params: params)
          .then((value) {
        if (isCancelByLeave) {
          _cancelTokens.remove(cancelToken);
        }
        return _dealWithResponse(
            value, path, "GET", params, isShowToast, isHiddenCommitLoading);
      }).catchError((e) {
        if (isCancelByLeave) {
          _cancelTokens.remove(cancelToken);
        }
        //隐藏loading
        if (buildContext != null && isHiddenCommitLoading) {
          hiddenCommit(context: buildContext!);
        }
        throw e;
      });
    } else {
      return HttpManager()
          .post(path,
              isShowToast: isShowToast,
              options: options,
              isPrintLog: isPrintLog,
              cancelToken: cancelToken,
              data: params)
          .then((value) {
        if (isCancelByLeave) {
          _cancelTokens.remove(cancelToken);
        }
        return _dealWithResponse(
            value, path, "POST", params, isShowToast, isHiddenCommitLoading);
      }).catchError((e) {
        if (isCancelByLeave) {
          _cancelTokens.remove(cancelToken);
        }
        //隐藏loading
        if (buildContext != null && isHiddenCommitLoading) {
          hiddenCommit(context: buildContext!);
        }

        throw e;
      });
    }
  }

  ///单文件上传
  Future<HttpResponse> uploadFile(String path,
      {base_dio.Options? options,
      bool isShowToast = true,
      bool isHiddenCommitLoading = true,
      bool isPrintLog = true,
      bool isCancelByLeave = true,
      Map<String, dynamic>? params}) async {
    params ??= {};
    final base_dio.FormData data = base_dio.FormData.fromMap(params);
    base_dio.CancelToken? cancelToken;
    if (isCancelByLeave) {
      cancelToken = base_dio.CancelToken();
      _cancelTokens.add(cancelToken);
    }
    return HttpManager()
        .upload(path,
            isShowToast: isShowToast,
            options: options,
            isPrintLog: isPrintLog,
            cancelToken: cancelToken,
            data: data)
        .then((value) {
      if (isCancelByLeave) {
        _cancelTokens.remove(cancelToken);
      }
      return _dealWithResponse(
          value, path, "UPLOAD", params, isShowToast, isHiddenCommitLoading);
    }).catchError((e) {
      if (isCancelByLeave) {
        _cancelTokens.remove(cancelToken);
      }
      //隐藏loading
      if (buildContext != null && isHiddenCommitLoading) {
        hiddenCommit(context: buildContext!);
      }
      throw e;
    });
  }

  ///处理请求结果
  ///与 Java 不同的是，Dart 的所有异常都是非必检异常，方法不一定会声明其所抛出的异常并且你也不会被要求捕获任何异常。所以这里如果外界需要处理异常就捕获，不需要就不捕获
  FutureOr<HttpResponse<dynamic>> _dealWithResponse(
      value,
      String path,
      String method,
      Map<String, dynamic>? params,
      bool isShowToast,
      bool isHiddenCommitLoading) {
    //隐藏loading
    if (buildContext != null && isHiddenCommitLoading) {
      hiddenCommit(context: buildContext!);
    }

    try {
      HttpResponse response = HttpResponse.fromJson(json.decode(value));
      //业务异常判断
      if (response.code != 1) {
        if (response.msg != null &&
            response.msg!.isNotEmpty &&
            isShowToast &&
            response.msg != "ok") {
          ToastUtils.show(response.msg!);
        }
        if (response.code != -1 && response.code != 0) {
          //TODO: 提交错误信息
          request(AppApi.errorUrl, params: {
            "api_url": path,
            "request_data": (params ?? {}).toString(),
            "msg": response.msg ?? ""
          });
        }
        throw HttpErrorException(
            errorType: HttpErrorType.business,
            code: response.code,
            response: response,
            msg: response.msg);
      }

      return response;
    } catch (e) {
      if (e is HttpErrorException && e.errorType == HttpErrorType.business) {
        switch (e.code) {
          case 0:
            LogUtils.onError(
                '===================> Error(业务错误 $method): $path \n 原因：请求失败 e:$e\n');
            break;
          case -1:
            LogUtils.onError(
                '===================> Error(业务错误 $method): $path \n 原因：鉴权错误 e:$e\n token:${AuthController.to.token}');
            break;
          case -2:
            LogUtils.onError(
                '===================> Error(业务错误 $method): $path \n 原因：token失效 e:$e\n');
            cancelRequest();
            if (!isLoginIndex) {
              //不在登录主页，就退出操作
              AuthController.to.logout(initiative: false);
            }
            break;
          default:
            LogUtils.onError(
                '===================> Error(业务错误 $method): $path \n 原因：错误码不存在 e:$e\n');
            break;
        }

        rethrow;
      } else if (e is FormatException) {
        //解析异常判断
        LogUtils.onError(
            '===================> Error(解析异常 $method): $path e:$e\n');
        ToastUtils.show('加载失败');
        throw HttpErrorException(errorType: HttpErrorType.json);
      } else {
        //其他异常判断
        ToastUtils.show('加载失败');
        throw HttpErrorException(errorType: HttpErrorType.other);
      }
    }
  }

  /////////////////////////////////////////////////////////////////////////////////
  //
  //                      工具方法
  //
  /////////////////////////////////////////////////////////////////////////////////

  ///显示提交的loading
  void showCommit({BuildContext? context, String msg = ""}) {
    ProgressDialog.showProgressText(context ?? buildContext, msg: msg);
  }

  ///隐藏提交loading
  void hiddenCommit({BuildContext? context}) {
    ProgressDialog.hideProgress(context ?? buildContext);
  }

  /// 关闭键盘
  void closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /////////////////////////////////////////////////////////////////////////////////
  //
  //                      刷新方法
  //
  /////////////////////////////////////////////////////////////////////////////////

  ///下拉刷新
  void pullRefresh() {}

  ///上拉加载
  void loadMore() {}

  ///重新加载
  void reLoadData() {}

  /////////////////////////////////////////////////////////////////////////////////
  //
  //                      生命周期
  //
  /////////////////////////////////////////////////////////////////////////////////

  @override
  void onDetached() {}

  @override
  void onInactive() {}

  ///切换到后台
  @override
  void onPaused() {}

  ///切换到前台
  @override
  void onResumed() {}

  ///切换到前台
  @override
  void onHidden() {}

  cancelRequest() {
    for (var element in _cancelTokens) {
      if (!element.isCancelled) {
        element.cancel();
      }
    }
  }

  @mustCallSuper
  @override
  void onClose() {
    _mounted = false;
    cancelRequest();
    super.onClose();
  }
}
