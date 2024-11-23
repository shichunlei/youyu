import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/auth_controller.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/modules/setting/account/sub/changenext/model/phone_change_model.dart';
import 'package:youyu/router/router.dart';
import 'package:youyu/widgets/app/input/app_verify_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneChangeNextLogic extends AppBaseController {
  late PhoneChangeModel model;

  ///key
  final GlobalKey<AppVerifyInputState> verifyKey = GlobalKey();

  TextEditingController mobileController = TextEditingController();
  TextEditingController verifyController = TextEditingController();

  //验证
  var isVerify = false.obs;

  @override
  void onInit() {
    super.onInit();
    model = Get.arguments;

    mobileController.addListener(() {
      isVerify.value =
          mobileController.text.isNotEmpty && verifyController.text.isNotEmpty;
    });
    verifyController.addListener(() {
      isVerify.value =
          verifyController.text.isNotEmpty && verifyController.text.isNotEmpty;
    });
  }

  ///发送验证码
  void sendSms() async {
    if (mobileController.text.isNotEmpty) {
      closeKeyboard();
      verifyKey.currentState?.countdownTimerEvent();
      showCommit();
      Map<String, dynamic> mData = {
        'mobile': mobileController.text,
        'type': SmsType.changePhone.type,
      };
      try {
        var value = await request(AppApi.smsUrl, params: mData);
        verifyKey.currentState?.countdownTimerEvent();
        ToastUtils.show(value.msg);
      } catch (e) {
        verifyKey.currentState?.cancelTimer();
      }
    } else {
      ToastUtils.show("请输入手机号");
    }
  }

  void requestCommit() {
    showCommit();
    request(AppApi.userChangePhoneUrl, params: {
      'mobile': mobileController.text,
      'code': verifyController.text
    }).then((value) {
      if (model.step == PhoneChangeStep.first) {
        Get.toNamed(AppRouter().settingPages.setPhoneChangeNextRoute.name,
            preventDuplicates: false,
            arguments:
                PhoneChangeModel(step: PhoneChangeStep.second, code: ""));
      } else {
        UserController.to.userInfo.value?.mobile = mobileController.text;
        ToastUtils.show("绑定成功");
        //TODO:直接第二步
        Get.until((route) =>
            route.settings.name ==
            AppRouter().settingPages.setAccountRoute.name);
      }
    });
  }

  @override
  void dispose() {
    verifyKey.currentState?.cancelTimer();
    super.dispose();
  }
}
