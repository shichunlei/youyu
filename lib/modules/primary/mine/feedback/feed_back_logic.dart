import 'package:youyu/utils/toast_utils.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class FeedBackLogic extends AppBaseController {
  TextEditingController contentController = TextEditingController();
  TextEditingController contactController = TextEditingController();

  var isVerify = false.obs;

  @override
  void onInit() {
    super.onInit();
    contentController.addListener(() {
      isVerify.value = contentController.text.isNotEmpty &&
          contactController.text.isNotEmpty;
    });
    contactController.addListener(() {
      isVerify.value = contentController.text.isNotEmpty &&
          contactController.text.isNotEmpty;
    });
  }

  onCommit() {
    if (isVerify.value) {
      showCommit();
      request(AppApi.userFeedBackUrl,params: {
        'proposal':contentController.text,
        'contact':contactController.text
      }).then((value) {
        //提交成功
        ToastUtils.show("提交成功");
        Get.back();
      });
    }
  }
}
