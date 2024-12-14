import 'package:youyu/utils/toast_utils.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/services/im/im_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_callback.dart';

class MessageRemarkLogic extends AppBaseController {
  int userId = 0;

  ///用户信息
  UserInfo? targetUserInfo;

  TextEditingController remarkController = TextEditingController();

  var isVerify = false.obs;

  @override
  void onInit() {
    super.onInit();
    userId = Get.arguments['userId'];
    targetUserInfo = Get.arguments['targetUserInfo'];

    remarkController.addListener(() {
      isVerify.value = remarkController.text.isNotEmpty;
    });

    if (targetUserInfo == null) {
      _loadData();
    } else {
      setSuccessType();
    }
  }

  _loadData() {
    setIsLoading = true;
    //获取他人信息
    UserController.to.fetchOtherInfo(userId)
        .then((value) {
      targetUserInfo = UserInfo.fromJson(value.data);
      setSuccessType();
    }).catchError((e) {
      setErrorType(e);
    });
  }

  requestCommit() async {
    if (remarkController.text.isNotEmpty) {
      showCommit();
      try {
        V2TimCallback callback =
            await IMService().setRemark(userId, remark: remarkController.text);
        if (callback.code == 0) {
          ToastUtils.show("设置成功");
        } else {
          ToastUtils.show("设置失败");
        }
        hiddenCommit();
      } catch (e) {
        ToastUtils.show("设置失败");
        hiddenCommit();
      }
    }
  }

  @override
  void reLoadData() {
    super.reLoadData();
    _loadData();
  }
}
