import 'package:youyu/utils/toast_utils.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/actionsheet/app_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/base/base_controller.dart';

class LoginFeedBackLogic extends AppBaseController {
  //内容
  TextEditingController qaContentController = TextEditingController();

  //登录方式
  TextEditingController loginTypeController = TextEditingController();
  int loginType = -1;

  //账号
  TextEditingController accountController = TextEditingController();

  //手机号
  TextEditingController mobileController = TextEditingController();
  FocusNode qaContentFocusNode = FocusNode();
  FocusNode loginTypeFocusNode = FocusNode();
  FocusNode accountFocusNode = FocusNode();
  FocusNode mobileFocusNode = FocusNode();

  var isCanCommit = false.obs;

  updateCommitState() {
    isCanCommit.value =
        qaContentController.text.isNotEmpty && mobileController.text.isNotEmpty;
  }

  onSelectLoginType() {
    closeKeyboard();
    // 1:手机2:微信3:qq4:苹果ID
    List<String> types = ["手机", "微信", "QQ", "苹果ID"];
    AppActionSheet().showSheet(
        theme: AppWidgetTheme.light,
        actions: types,
        onClick: (index) {
          loginType = index + 1;
          loginTypeController.text = types[index];
        });
  }

  requestCommit() async {
    if (isCanCommit.value) {
      closeKeyboard();
      showCommit();
      var value = await request(AppApi.loginFeedBackUrl, params: {
        "content": qaContentController.text,
        "account": accountController.text,
        "login_type": loginType.toString(),
        "mobile": mobileController.text
      });
      ToastUtils.show(value.msg);
      Get.back();
    }
  }
}
