import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/models/localmodel/image_model.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/modules/submod/user/detail/sub/edit/sub/user_edit_sub_logic.dart';
import 'package:youyu/router/router.dart';
import 'package:youyu/services/image_upload_service.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/actionsheet/app_action_sheet.dart';
import 'package:youyu/widgets/app/actionsheet/app_date_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UserEditLogic extends AppBaseController {
  //头像相关
  Rx<ImageModel?> imageModel = Rx(null);

  //昵称
  TextEditingController nickNameController = TextEditingController();

  //性别
  int sex = 0;

  //生日
  int birthDayTime = 0;

  //个性签名
  TextEditingController signController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    nickNameController.text = UserController.to.nickname;
    sex = UserController.to.gender;
    birthDayTime = UserController.to.userInfo.value?.birthTime ?? 0;
    signController.text = UserController.to.userInfo.value?.signature ?? "";
    setSuccessType();
  }

  ///选择相册
  selectHead() {
    ImageUploadService().selectPicker((isSuccess, {model}) {
      if (isSuccess) {
        imageModel.value = model;
        _requestCommit();
      }
    });
  }

  ///昵称
  onPushNickName() {
    Get.toNamed(AppRouter().otherPages.userSubEditRoute.name,
            arguments: UserEditType.nickName)
        ?.then((value) {
      nickNameController.text = UserController.to.nickname;
      _updateUserInfo();
    });
  }

  ///签名
  pushToSign() {
    Get.toNamed(AppRouter().otherPages.userSubEditRoute.name,
            arguments: UserEditType.sign)
        ?.then((value) {
      signController.text = UserController.to.userInfo.value?.signature ?? "";
      _updateUserInfo();
    });
  }

  ///选择性别
  selectSex() {
    List<String> data = ["男", "女"];
    AppActionSheet().showSheet(
        theme: AppWidgetTheme.light,
        actions: data,
        onClick: (index) {
          // sexController.text = data[index];
          sex = index + 1;
          _requestCommit();
        });
  }

  ///生日
  selectBirthDay() {
    AppDataPicker.showDatePiker(Get.context, onConfirm: (date) {
      // birthDayController.text = "$date".substring(0, 10);
      birthDayTime = date.millisecondsSinceEpoch ~/ 1000;
      _requestCommit();
    });
  }

  _requestCommit() async {
    showCommit();
    try {
      Map<String, dynamic> params = {
        'nickname': nickNameController.text,
        'gender': sex,
        'birth_time': birthDayTime,
        'signature': signController.text
      };
      if (imageModel.value != null) {
        params['avatar'] = imageModel.value?.imageId;
      }
      await request(AppApi.userEditUrl, params: params);
      _updateUserInfo();
      ToastUtils.show("保存成功");
    } catch (e) {
      hiddenCommit();
    }
  }

  _updateUserInfo() {
    UserInfo? userInfo = UserController.to.userInfo.value;
    userInfo?.gender = sex;
    userInfo?.nickname = nickNameController.text;
    userInfo?.signature = signController.text;
    userInfo?.birthTime = birthDayTime;
    if (imageModel.value != null) {
      userInfo?.avatar = imageModel.value?.imageUrl;
    }
    UserController.to.userInfo.value = userInfo;
    setSuccessType();
  }
}
