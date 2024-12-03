import 'package:youyu/utils/log_utils.dart';
import 'package:youyu/utils/platform_utils.dart';
import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/config/config.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/controllers/auth_controller.dart';
import 'package:get/get.dart';

import '../../../controllers/base/base_controller.dart';
import 'package:ali_auth/ali_auth.dart';

class LoginIndexLogic extends AppBaseController {
  //本页面是否同意协议
  var isAgree = false.obs;

  //一键登录页面是否同意协议
  bool isSubAgree = false;

  //是否注册(默认为1，方便检测是否注册)
  int userIsSet = 1;

  //一键登录页面配置
  AliAuthModel aliAuthModel = AliAuthModel(
      AppConfig.aliKeyAndroid, AppConfig.aliKeyIos,
      isDelay: false,
      isDebug: true,

      ///页面方式
      pageType: PageType.fullPort,
      navColor: '#FFFFFFFF',
      dialogHeight: -1,
      dialogBottom: false,
      dialogOffsetX: -1,
      dialogOffsetY: -1,
      dialogWidth: -1,
      dialogAlpha: 1.0,
      screenOrientation: -1,

      ///状态栏
      statusBarColor: '#FF1E1E1E',
      isLightColor: false,
      isStatusBarHidden: false,
      statusBarUIFlag: UIFAG.systemUiFalgFullscreen,

      ///导航
      navText: "一键登录",
      navHidden: false,
      navTextColor: "#000000",
      navTextSize: 18,
      navReturnImgPath: AppResource().blackBack,
      navReturnImgWidth: 20 ~/ 2,
      navReturnImgHeight: 37 ~/ 2,
      navReturnHidden: false,
      navReturnScaleType: ScaleType.center,

      ///背景
      backgroundPath: AppResource().aliBg,
      pageBackgroundPath: AppResource().aliBg,

      ///底部背景
      bottomNavColor: "#FF1E1E1E",

      ///logo
      logoImgPath: AppResource().bigLogo,
      logoHidden: false,
      logoWidth: 103 ~/ 1.5,
      logoHeight: 103 ~/ 1.5,
      logoOffsetY: 50,
      logoOffsetY_B: -1,
      logoScaleType: ScaleType.fitXy,

      ///手机号
      numberColor: "#000000",
      numberSize: 22,
      numFieldOffsetY: (73 + 50 + 36),
      numFieldOffsetY_B: -1,
      numberFieldOffsetX: -1,
      numberLayoutGravity: Gravity.centerHorizntal,

      ///切换其他方式（隐藏）
      switchAccHidden: true,
      switchAccTextColor: "#3BBEFF",
      switchOffsetY: -1,
      switchOffsetY_B: 190,
      switchAccTextSize: 16,
      switchAccText: "切换到其他方式",

      ///提示语
      sloganText: '中国联通提供认证服务',
      sloganTextColor: '#999999',
      sloganTextSize: 14,
      sloganHidden: false,
      sloganOffsetY: (73 + 50 + 36 + 24 + 10),

      ///登录按钮
      logBtnText: "本机号码一键登录",
      logBtnTextSize: 17,
      logBtnTextColor: "#FFFFFF",
      logBtnBackgroundPath:
          "${AppResource().aliBtn},${AppResource().aliBtn},${AppResource().aliBtn}",
      logBtnOffsetY_B: -1,
      logBtnOffsetY: (73 + 50 + 36 + 24 + 10 + 28 + 15),
      logBtnHeight: 50,
      logBtnOffsetX: -1,
      logBtnMarginLeftAndRight: 55,
      logBtnLayoutGravity: Gravity.centerHorizntal,

      ///协议
      privacyOffsetX: -1,
      protocolOneName: "《用户协议》",
      protocolOneURL: "/#/agreement/6",
      protocolTwoName: "《隐私政策》",
      protocolTwoURL: "/#/agreement/7",
      vendorPrivacyPrefix: "《",
      vendorPrivacySuffix: "》",

      ///IOS的颜色
      protocolOwnColor: "#2FE9FE",
      protocolOwnOneColor: "#2FE9FE",
      protocolOwnTwoColor: "#2FE9FE",

      ///android的颜色
      protocolColor: "#333333",
      protocolCustomColor: "#2FE9FE",
      protocolLayoutGravity: Gravity.centerHorizntal,
      privacyOffsetY: -1,
      privacyOffsetY_B: 28,
      checkBoxWidth: 18,
      checkBoxHeight: 18,
      checkboxHidden: false,
      uncheckedImgPath: AppResource().unCheck,
      checkedImgPath: AppResource().check,
      privacyState: false,
      protocolGravity: Gravity.centerHorizntal,
      privacyTextSize: 12,
      privacyMargin: 28,
      privacyBefore: "我已阅读并同意",
      privacyEnd: "",
      isHiddenLoading: true,

      ///web
      webViewStatusBarColor: "#FF1E1E1E",
      webNavColor: "#FFFFFFFF",
      webNavTextColor: "#FFFFFFFF",
      webNavTextSize: 18,
      webNavReturnImgPath:
          PlatformUtils.isIOS ? AppResource().smallBack : AppResource().back,
      webSupportedJavascript: true,
      authPageActIn: "in_activity",
      activityOut: "out_activity",
      authPageActOut: "in_activity",
      activityIn: "out_activity",
      privacyOperatorIndex: 0,
      isHideToast: false,
      logBtnToastHidden: false);

  @override
  void onInit() {
    super.onInit();
    setIsLoginIndex = true;
    _aliAuthListener();
  }

  ///一键登录监听
  _aliAuthListener() {
    AliAuth.loginListen(onEvent: (onEvent) {
      hiddenCommit();
      LogUtils.onPrint("----------------> $onEvent <----------------");
      if (onEvent['code'] == "600000") {
        isSubAgree = false;
        //请求一键登录
        String token = onEvent['data'];
        // print(token);
        AuthController.to.oneKeyLogin(accessToken: token);
      } else if (onEvent['code'] == "500004" ||
          onEvent['code'] == "600001" ||
          onEvent['code'] == "600024" ||
          onEvent['code'] == "700004" ||
          onEvent['code'] == "600026") {
        //这些code都不提示
      } else if (onEvent['code'] == '600012') {
        //预取号失败 - 不提示
      } else if (onEvent['code'] == "700000") {
        //用户取消 - 重置是否同意协议
        isSubAgree = false;
      } else if (onEvent['code'] == "700003") {
        //用户操作协议
        isSubAgree = !isSubAgree;
      } else if (onEvent['code'] == "700002") {
        //用户点击登录
        if (!isSubAgree) {
          ToastUtils.show("请先勾选同意隐私政策与用户协议");
        }
      } else {
        //其他提示语
        ToastUtils.show(onEvent['msg']);
      }
    });
  }

  ///一键登录初始化
  onClickOneKey() async {
    showCommit();
    await AliAuth.initSdk(aliAuthModel);
  }

  @override
  void onClose() {
    super.onClose();
    AliAuth.dispose();
  }
}
