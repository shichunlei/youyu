import 'package:youyu/utils/toast_utils.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

enum UserEditType { nickName, sign }

class UserEditSubLogic extends AppBaseController {
  UserEditType editType = UserEditType.nickName;

  TextEditingController controller = TextEditingController();

  var isVerify = false.obs;

  @override
  void onInit() {
    super.onInit();
    editType = Get.arguments;
    if (editType == UserEditType.nickName) {
      controller.text = UserController.to.nickname;
    } else {
      controller.text = UserController.to.userInfo.value?.signature ?? "";
    }
    isVerify.value = controller.text.isNotEmpty;
    controller.addListener(() {
      isVerify.value = controller.text.isNotEmpty;
    });
  }

  requestCommit() async {
    showCommit();
    try {
      Map<String, dynamic> params = {};
      if (editType == UserEditType.nickName) {
        params['nickname'] = controller.text;
      } else {
        params['signature'] = controller.text;
      }
      await request(AppApi.userEditUrl, params: params);
      _updateUserInfo();
      ToastUtils.show("保存成功");
      Get.back();
    } catch (e) {
      hiddenCommit();
    }
  }

  _updateUserInfo() {
    UserInfo? userInfo = UserController.to.userInfo.value;
    if (editType == UserEditType.nickName) {
      userInfo?.nickname = controller.text;
    } else {
      userInfo?.signature = controller.text;
    }
    UserController.to.userInfo.value = userInfo;
  }

}
