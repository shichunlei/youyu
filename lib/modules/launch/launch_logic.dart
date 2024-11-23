import 'dart:io';

import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/services/http/http_error.dart';
import 'package:youyu/services/http/http_service.dart';
import 'package:youyu/utils/log_utils.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/app_controller.dart';
import 'package:youyu/controllers/auth_controller.dart';
import 'package:youyu/controllers/gift_controller.dart';
import 'package:youyu/models/app_init_data.dart';
import 'package:youyu/router/router.dart';
import 'package:youyu/services/async_down_service.dart';
import 'package:youyu/services/im/im_error.dart';
import 'package:youyu/services/im/im_service.dart';
import 'package:youyu/services/trtc/trtc_service.dart';
import 'package:youyu/services/voice_service.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/dialog/app_tip_dialog.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class LaunchLogic extends AppBaseController {
  @override
  void onInit() async {
    super.onInit();
    //0.保持常亮
    WakelockPlus.enable();
    //1.初始话服务
    await _initService();
    //2.获取配置接口
    _requestAppConfig();
  }

  ///服务
  _initService() async {
    await HttpService().initHttp();
    AsyncDownService().onInit();
    IMService().onInit();
    TRTCService().onInit();
    VoiceService().onInit();
  }

  ///获取首个接口
  _requestAppConfig() {
    //暂不加loading
    request(AppApi.configUrl,
            isShowToast: false, isPrintLog: false, isHiddenCommitLoading: false)
        .then((value) {
      ///记录信息
      AppInitData data = AppInitData.fromJson(value.data);
      //1.app全局信息
      AppController.to.appInitData.value = data;
      //2.礼物信息
      GiftController.to.onInitData(data.giftList);
      //3.权限申请
      _initPermission();
      //4.检测版本
      _checkVersion();
    }).catchError((e) {
      String? msg;
      if (e is HttpErrorException) {
        msg = e.msg;
      }
      _errorAlert(msg ?? "加载失败,请确保打开手机网络链接");
    });
  }

  _errorAlert(String error, {bool isCheckVersion = false}) {
    AppTipDialog().showTipDialog("提示", AppWidgetTheme.light,
        msg: error, commitBtn: "点击重试", onCommit: () {
      showCommit();
      if (isCheckVersion) {
        _checkVersion();
      } else {
        _requestAppConfig();
      }
    }, onCancel: () {
      exit(0);
    });
  }

  //初始化App权限(读取权限先进入是请求)
  _initPermission() async {
    try {
      if (await Permission.manageExternalStorage.request().isGranted) {
        LogUtils.onPrint("request manageExternalStorage");
      }
      if (await Permission.storage.request().isGranted) {
        LogUtils.onPrint("request storage");
      }
    } catch (e) {
      LogUtils.onError(e);
    }
  }

  // Get.offAndToNamed(AppRouter().testRoute.name); //测试
  ///进入tabIndex||login
  _checkVersion() async {
    //3.版本信息
    AppController.to.enterCheckVersion(onIgnore: () {
      _enterIndex();
    }, onError: () {
      _errorAlert("网络加载失败，请重试");
    });
  }

  _enterIndex() async {
    if (AuthController.to.isLogin) {
      try {
        await AuthController.to.autoLogin();
        hiddenCommit();
        Get.offAllNamed(AppRouter().indexRoute.name);
      } catch (e) {
        hiddenCommit();
        if (e is IMErrorException) {
          _errorAlert("聊天服务加载失败,请确保打开手机网络链接");
        } else {
          _errorAlert("加载失败,请确保打开手机网络链接");
        }
      }
    } else {
      hiddenCommit();
      Get.offAndToNamed(AppRouter().loginPages.loginIndexRoute.name);
    }
  }
}
