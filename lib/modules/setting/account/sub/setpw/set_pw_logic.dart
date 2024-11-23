import 'package:youyu/utils/toast_utils.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/auth_controller.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/widgets/app/input/app_verify_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SetPwType {
  set, //设置
  change //更换
}

class SetPwLogic extends AppBaseController {
  SetPwType pwType = SetPwType.set;

  ///key
  final GlobalKey<AppVerifyInputState> verifyKey = GlobalKey();

  TextEditingController verifyController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  TextEditingController twicePwController = TextEditingController();

  //验证
  var isVerify = false.obs;

  @override
  void onInit() {
    super.onInit();
    pwType = Get.arguments;
    _initVerify();
  }

  _initVerify() {
    verifyController.addListener(() {
      if (pwType == SetPwType.set) {
        isVerify.value =
            pwController.text.isNotEmpty && twicePwController.text.isNotEmpty;
      } else {
        isVerify.value = pwController.text.isNotEmpty &&
            twicePwController.text.isNotEmpty &&
            twicePwController.text.isNotEmpty;
      }
    });
    pwController.addListener(() {
      if (pwType == SetPwType.set) {
        isVerify.value =
            pwController.text.isNotEmpty && twicePwController.text.isNotEmpty;
      } else {
        isVerify.value = pwController.text.isNotEmpty &&
            twicePwController.text.isNotEmpty &&
            twicePwController.text.isNotEmpty;
      }
    });
    twicePwController.addListener(() {
      if (pwType == SetPwType.set) {
        isVerify.value =
            pwController.text.isNotEmpty && twicePwController.text.isNotEmpty;
      } else {
        isVerify.value = pwController.text.isNotEmpty &&
            twicePwController.text.isNotEmpty &&
            verifyController.text.isNotEmpty;
      }
    });
  }

  ///发送验证码
  void sendSms() async {
    closeKeyboard();
    showCommit();
    Map<String, dynamic> mData = {
      'mobile': UserController.to.mobile,
      'type': SmsType.changePw.type,
    };
    try {
      var value = await request(AppApi.smsUrl, params: mData);
      verifyKey.currentState?.countdownTimerEvent();
      ToastUtils.show(value.msg);
    } catch (e) {
      verifyKey.currentState?.cancelTimer();
    }
  }

  ///提交
  requestCommit() {
    if (isVerify.value) {
      showCommit();
      if (pwType == SetPwType.set) {
        request(AppApi.userChangePwUrl,
            params: {'password': pwController.text}).then((value) {
          UserController.to.userInfo.value?.isPass = 1;
          ToastUtils.show("设置成功");
          Get.back(result: true);
        });
      } else {
        request(AppApi.userChangePwUrl, params: {
          'mobile': UserController.to.mobile,
          'password': pwController.text,
          'code': verifyController.text
        }).then((value) {
          UserController.to.userInfo.value?.isPass = 1;

          ToastUtils.show("修改成功");
          Get.back(result: true);
        });
      }
    }
  }
}
