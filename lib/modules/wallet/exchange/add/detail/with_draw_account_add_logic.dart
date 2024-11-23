import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/router/router.dart';

class WithDrawAccountAddLogic extends AppBaseController {
  //姓名
  TextEditingController nameController = TextEditingController();

  //身份证号
  TextEditingController numberController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode numberFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    nameController.addListener(() {
      isVerify.value =
          (nameController.text.isNotEmpty && numberController.text.isNotEmpty);
    });
    numberController.addListener(() {
      isVerify.value = (numberController.text.isNotEmpty &&
          numberController.text.isNotEmpty);
    });
  }

  ///验证
  var isVerify = false.obs;

  onCommit() {
    request(AppApi.walletSaveAccountUrl, params: {
      'type': 1,
      'name': nameController.text,
      'account': numberController.text,
    }).then((value) {
      ToastUtils.show("提交成功");
      Get.until((route) =>
          route.settings.name ==
          AppRouter().walletPages.exchangeRoute.name);
    });
  }

  @override
  void onClose() {
    super.onClose();
    nameFocusNode.dispose();
    numberFocusNode.dispose();
  }
}
