import 'package:youyu/utils/toast_utils.dart';
import 'package:youyu/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/base/base_controller.dart';
///账号密码登录（登录之前一定完善过信息了）
class LoginAccountLogic extends AppBaseController {
  var isAgree = false.obs;
  TextEditingController accountController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  FocusNode accountFocusNode = FocusNode();
  FocusNode pwFocusNode = FocusNode();

  requestCommit() {
    closeKeyboard();
    if (isAgree.value) {
      if (accountController.text.isNotEmpty == false) {
        ToastUtils.show('请输入手机号/ID');
        return;
      }
      if (pwdController.text.isNotEmpty == false) {
        ToastUtils.show('请输入密码');
        return;
      }
      AuthController.to
          .accountLogin(account: accountController.text, pw: pwdController.text);
    } else {
      ToastUtils.show("请先勾选同意隐私政策与用户协议");
    }
  }

}
