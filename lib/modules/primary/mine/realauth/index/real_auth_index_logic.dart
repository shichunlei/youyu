
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/router/router.dart';

class RealAuthIndexLogic extends AppBaseController {
  //姓名
  TextEditingController nameController = TextEditingController();

  //身份证号
  TextEditingController numberController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();
  FocusNode numberFocusNode = FocusNode();

  var isVerify = false.obs;

  @override
  void onInit() {
    super.onInit();
    nameController.addListener(() {
      isVerify.value =
          (nameController.text.isNotEmpty && numberController.text.isNotEmpty);
    });
    numberController.addListener(() {
      isVerify.value =
          (nameController.text.isNotEmpty && numberController.text.isNotEmpty);
    });
  }

  gotoFinish() {
    showCommit();
    FocusManager.instance.primaryFocus?.unfocus();
    request(AppApi.userCommitRealUrl, params: {
      'name': nameController.text,
      'id_num': numberController.text
    }).then((value) {
      Get.offNamed(AppRouter().otherPages.realAuthDetailRoute.name);
    });
  }

  @override
  void onClose() {
    super.onClose();
    nameFocusNode.dispose();
    numberFocusNode.dispose();
  }
}
