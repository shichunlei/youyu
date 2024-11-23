import 'package:youyu/utils/toast_utils.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/widgets/app/input/app_verify_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../controllers/base/base_controller.dart';

class PwResetLogic extends AppBaseController {
  var isAgree = false.obs;

  ///key
  final GlobalKey<AppVerifyInputState> loginVerifyKey = GlobalKey();

  TextEditingController mobileController = TextEditingController();
  TextEditingController verifyController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  FocusNode mobileFocusNode = FocusNode();
  FocusNode pwFocusNode = FocusNode();
  FocusNode verifyFocusNode = FocusNode();

  ///发送验证码
  void sendSms() async {
    if (mobileController.text.isNotEmpty) {
      closeKeyboard();
      showCommit();
      Map<String, dynamic> mData = {
        'mobile': mobileController.text,
        'type': SmsType.findPw.type,
      };
      try {
        var value = await request(AppApi.smsUrl, params: mData);
        loginVerifyKey.currentState?.countdownTimerEvent();
        ToastUtils.show(value.msg);
      } catch (e) {
        loginVerifyKey.currentState?.cancelTimer();
      }
    } else {
      ToastUtils.show("请输入手机号");
    }
  }

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
      if (pwdController.text.isNotEmpty == false) {
        ToastUtils.show('请输入密码');
        return;
      }
      _resetLogin();
    } else {
      ToastUtils.show("请先勾选同意隐私政策与用户协议");
    }
  }

  _resetLogin() async {
    showCommit();
    var value = await request(AppApi.findPwUrl, params: {
      "mobile": mobileController.text,
      "code": verifyController.text,
      "password": pwdController.text
    });
    ToastUtils.show(value.msg);
    Get.back();
  }
}
