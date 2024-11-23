
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/modules/primary/mine/children/childrenpw/model/children_pw_model.dart';
import 'package:get/get.dart';
import 'package:youyu/router/router.dart';

class ChildrenLogic extends AppBaseController {
  String title = "青少年模式";
  String text1 = "1.青少年模式开启后，主页将会展示适合青少年的内容，且无法进行充值等相关操作。";
  String text2 = "2.开启青少年模式，需先设置独立密码，如忘记密码可通过找回密码界面验证信息后重置。";
  String text3 =
      "3.青少年模式是嘿嘿语音为保护青少年用网环境的一次尝试，我们将在后续不断优化更多功能，如有任何建议请通过平台内(在线客服] 与我们联系。";

  ///开启或修改
  onOpenChildren() {
    if (UserController.to.childrenControl.isOpenChildren.value) {
      Get.toNamed(AppRouter().otherPages.childrenPwRoute.name,
          arguments: ChildrenPwModel(
              pwType: ChildrenPwType.change,
              pwStep: ChildrenPwStep.step1,
              stepPw: []));
    } else {
      Get.toNamed(AppRouter().otherPages.childrenPwRoute.name,
          arguments: ChildrenPwModel(
              pwType: ChildrenPwType.open,
              pwStep: ChildrenPwStep.step1,
              stepPw: []));
    }
  }

  ///关闭
  onCloseChildren() {
    Get.toNamed(AppRouter().otherPages.childrenPwRoute.name,
        arguments: ChildrenPwModel(
            pwType: ChildrenPwType.close,
            pwStep: ChildrenPwStep.step1,
            stepPw: []));
  }
}
