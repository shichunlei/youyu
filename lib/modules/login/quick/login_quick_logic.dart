import 'package:youyu/utils/toast_utils.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/router/router.dart';
import 'package:youyu/widgets/app/input/app_verify_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/base/base_controller.dart';
import '../info/param/login_info_param.dart';

class LoginQuickLogic extends AppBaseController {
  var isAgree = false.obs;

  ///key
  final GlobalKey<AppVerifyInputState> loginVerifyKey = GlobalKey();

  TextEditingController mobileController = TextEditingController();
  TextEditingController verifyController = TextEditingController();

  FocusNode mobileFocusNode = FocusNode();
  FocusNode verifyFocusNode = FocusNode();

  //是否注册(默认为1，方便检测是否注册)
  int userIsSet = 1;

  ///发送验证码
  void sendSms() async {
    if (mobileController.text.isNotEmpty) {
      showCommit();
      closeKeyboard();
      userIsSet = 1;
      Map<String, dynamic> mData = {
        'mobile': mobileController.text,
        'type': SmsType.registerLogin.type,
      };
      try {
        var value = await request(AppApi.smsUrl, params: mData);
        loginVerifyKey.currentState?.countdownTimerEvent();
        userIsSet = value.data["user_isset"] ?? 0;
        ToastUtils.show(value.msg);
      } catch (e) {
        loginVerifyKey.currentState?.cancelTimer();
      }
    } else {
      ToastUtils.show("请输入手机号");
    }
  }

  ///提交
  void requestCommit() {
    if (isAgree.value) {
      if (mobileController.text.isNotEmpty == false) {
        ToastUtils.show('请输入手机号');
        return;
      }
      if (verifyController.text.isNotEmpty == false) {
        ToastUtils.show('请输入验证码');
        return;
      }
      _quickLogin();
    } else {
      ToastUtils.show("请先勾选同意隐私政策与用户协议");
    }
  }

  ///快捷登录
  _quickLogin() {
    if (userIsSet == 1) {
      //注册之后，直接验证码登录
      AuthController.to.quickLogin(
          mobile: mobileController.text, code: verifyController.text);
    } else {
      //进入注册信息
      Get.toNamed(AppRouter().loginPages.loginInfoRoute.name,
          arguments: LoginInfoParam(
              mobile: mobileController.text, code: verifyController.text));
    }
  }
}
