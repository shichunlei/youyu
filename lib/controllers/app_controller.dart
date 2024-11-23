import 'package:youyu/config/theme.dart';
import 'package:youyu/models/version.dart';
import 'package:youyu/utils/platform_utils.dart';
import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/utils/uuid_utils.dart';
import 'package:youyu/utils/version_utils.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/auth_controller.dart';
import 'package:youyu/models/banner_model.dart';
import 'package:youyu/modules/primary/home/list/recommend/model/recommend_banner_model.dart';
import 'package:youyu/modules/submod/web/param/web_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import 'package:youyu/router/router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';
import 'package:youyu/widgets/app/dialog/app_tip_dialog.dart';
import '../models/app_init_data.dart';
import 'base/base_controller.dart';


///全局管理
class AppController extends AppBaseController {
  static AppController get to => Get.find<AppController>();

  ///app版本号
  String _version = "";

  String get version => _version;

  ///构建版本号
  String _buildNumber = "";

  String get buildNumber => _buildNumber;

  ///设备号
  String _deviceId = "";

  String get deviceId => _deviceId;

  ///全局服务数据
  Rx<AppInitData?> appInitData = Rx(null);

  ///链接相关
  //用户协议
  String get userAgreement => appInitData.value?.userAgreement ?? "";

  //隐私政策
  String get privacyAgreement => appInitData.value?.privacyAgreement ?? "";

  //充值协议
  String get rechargeAgreement => appInitData.value?.privacyAgreement ?? "";

  ///常用全局配置数据
  //默认用户头像配置
  String get userDefaultAvatar => appInitData.value?.userDefaultAvatar ?? "";

  //im的用户前缀配置
  String get tencentUserPrefix => appInitData.value?.tencentUserPrefix ?? "";

  //是否开启震动
  var hasVibrator = false.obs;

  ///全局变量
  //总的未读消息数据
  final _unMsgRedCount = 0.obs;

  int get unMsgRedCount => _unMsgRedCount.value;

  //im未读
  final _imUnReadCount = 0.obs;

  int get imUnReadCount => _imUnReadCount.value;

  //系统/公告未读
  var sysUnReadCount = 0.obs;
  var noticeUnReadCount = 0.obs;
  int _sysNoticeUnReadCount = 0;

  ///首页banner
  Rx<RecommendBannerModel?> bannerModel = Rx(null);

  //更新im消息未读
  updateIMUnReadCount(int count) {
    _imUnReadCount.value = count;
    _unMsgRedCount.value = count + _sysNoticeUnReadCount;
  }

  requestSysNoticeUnReadCount() async {
    if (AuthController.to.isLogin) {
      try {
        var value = await request(AppApi.msgSysAndNoticeUnReadUrl);
        AppController.to.updateSysNoticeUnReadCount(value.data['all'],
            sysUnReadCount: value.data['system'],
            noticeUnReadCount: value.data['notice']);
      } catch (e) {
        //...
      }
    }
  }

  //更新系统/公告未读
  updateSysNoticeUnReadCount(int count,
      {required int sysUnReadCount, required int noticeUnReadCount}) {
    _sysNoticeUnReadCount = count;
    this.sysUnReadCount.value = sysUnReadCount;
    this.noticeUnReadCount.value = noticeUnReadCount;
    _unMsgRedCount.value = count + _imUnReadCount.value;
  }

  @override
  void onInit() async {
    super.onInit();
    _initAppInfo();
    bool? hasVibratorStatus = await Vibration.hasVibrator();
    hasVibrator.value = hasVibratorStatus ?? false;

    // 网络状态消息订阅
    Connectivity().onConnectivityChanged.listen((ConnectivityResult event) {});
  }

  _initAppInfo() async {
    // 获取版本号信息
    _version = await VersionUtils.getVersionCode();
    _buildNumber = await VersionUtils.getBuildCode();
    // 获取设备ID
    _deviceId = await DeviceUtils.getDeviceId();

    if (PlatformUtils.isAndroid) {
      await _requestPermissions();
      _initForeground();
    }
  }

  Future<void> _requestPermissions() async {
    if (PlatformUtils.isAndroid) {
      final NotificationPermission notificationPermissionStatus =
          await FlutterForegroundTask.checkNotificationPermission();
      if (notificationPermissionStatus != NotificationPermission.granted) {
        await FlutterForegroundTask.requestNotificationPermission();
      }
    }
  }

  ///初始化这个前台任务
  _initForeground() {
    FlutterForegroundTask.init(
        androidNotificationOptions: AndroidNotificationOptions(
            channelImportance: NotificationChannelImportance.LOW,
            priority: NotificationPriority.LOW,
            channelId: 'match_live',
            channelName: 'match_live'),
        iosNotificationOptions: const IOSNotificationOptions(),
        foregroundTaskOptions: ForegroundTaskOptions(
          eventAction: ForegroundTaskEventAction.once(),
          autoRunOnBoot: true,
          autoRunOnMyPackageReplaced: true,
          allowWakeLock: true,
          allowWifiLock: true,
        ));
  }

  ///banner点击
  ///0:不跳转 1:内部跳转 2:网页跳转 数藏选2 值写跳转地址
  onClickBanner(BannerModel model) async {
    switch (model.type ?? 0) {
      case 0:
        break;
      case 1:
        Get.toNamed(AppRouter().otherPages.webRoute.name,
            arguments: WebParam(url: model.val ?? "", title: ""));
        break;
      case 2:
        Uri uri = Uri.parse(model.val ?? "");
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
        break;
    }
  }

  ///进入是检测版本
  enterCheckVersion(
      {Function? onIgnore, Function? onError, bool isShowToast = false}) async {
    try {
      String version = await VersionUtils.getVersionCode();
      var value = await request(AppApi.versionUrl,
          params: {
            'type': PlatformUtils.isAndroid ? "1" : "2",
            'version': version
          },
          isShowToast: isShowToast);
      if (value.data != null) {
        Version version = Version.fromJson(value.data);
        AppTipDialog().showTipDialog(
            onWillPop: false,
            "您有新的版本:${version.num}",
            AppWidgetTheme.dark,
            msg: version.content,
            onlyCommit: version.isForce == 1,
            cancelBtn: "忽略",
            commitBtn: "更新",
            isAutoBack: false, onCommit: () async {
          Uri uri = Uri.parse(version.url ?? "");
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }, onCancel: () {
          Get.back();
          if (onIgnore != null) {
            onIgnore();
          }
        });
      } else {
        if (isShowToast) {
          ToastUtils.show("已是最新版本");
        }
        Get.back();
        if (onIgnore != null) {
          onIgnore();
        }
      }
    } catch (e) {
      if (onError != null) {
        onError();
      }
    }
  }

  ///退出登录重置
  void resetByLoginOut() {
    _unMsgRedCount.value = 0;
    _imUnReadCount.value = 0;
    sysUnReadCount.value = 0;
    noticeUnReadCount.value = 0;
    _sysNoticeUnReadCount = 0;
  }
}
