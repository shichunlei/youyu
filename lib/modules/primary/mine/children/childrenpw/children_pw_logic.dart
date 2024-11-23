import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/modules/primary/mine/children/childrenpw/model/children_pw_model.dart';
import 'package:get/get.dart';
import 'package:youyu/router/router.dart';

class ChildrenPwLogic extends AppBaseController {
  late ChildrenPwModel pwModel;

  //标题
  String? title;

  //副标题
  String? subTitle;

  //底部按钮
  String? btnTitle;

  //是否显示找回
  bool isShowFind = false;

  //密码
  var password = "".obs;

  @override
  void onInit() {
    super.onInit();
    pwModel = Get.arguments;

    switch (pwModel.pwType) {
      case ChildrenPwType.open: //需要2步
        if (pwModel.pwStep == ChildrenPwStep.step1) {
          title = "设置密码";
          subTitle = "启动青少年模式，需先设置独立密码";
          btnTitle = "下一步";
          isShowFind = false;
        } else if (pwModel.pwStep == ChildrenPwStep.step2) {
          title = "确认密码";
          subTitle = "请再次输入密码";
          btnTitle = "完成";
          isShowFind = false;
        }
        break;
      case ChildrenPwType.change: //需要3步
        if (pwModel.pwStep == ChildrenPwStep.step1) {
          title = "修改密码";
          subTitle = "请输入当前密码";
          btnTitle = "下一步";
          isShowFind = true;
        } else if (pwModel.pwStep == ChildrenPwStep.step2) {
          title = "请输入新密码";
          subTitle = "";
          btnTitle = "下一步";
          isShowFind = false;
        } else if (pwModel.pwStep == ChildrenPwStep.step3) {
          title = "再次输入新密码";
          subTitle = "";
          btnTitle = "完成";
          isShowFind = false;
        }
        break;
      case ChildrenPwType.close: //需要1步
        if (pwModel.pwStep == ChildrenPwStep.step1) {
          title = "关闭青少年模式";
          subTitle = "请输入当前密码";
          btnTitle = "完成";
          isShowFind = true;
        }
        break;
    }
  }

  ///提交
  onCommit() {
    if (password.value.length == 4) {
      switch (pwModel.pwType) {
        case ChildrenPwType.open: //需要2步
          _onOpenCommit();
          break;
        case ChildrenPwType.change: //需要3步
          _onChangeCommit();
          break;
        case ChildrenPwType.close: //需要1步
          _onCloseCommit();
          break;
      }
    }
  }

  //开启提交
  _onOpenCommit() {
    if (pwModel.pwStep == ChildrenPwStep.step1) {
      Get.toNamed(AppRouter().otherPages.childrenPwRoute.name,
          preventDuplicates: false,
          arguments: ChildrenPwModel(
              pwType: pwModel.pwType,
              pwStep: ChildrenPwStep.step2,
              stepPw: [password.value]));
    } else if (pwModel.pwStep == ChildrenPwStep.step2) {
      String? beforePw = pwModel.stepPw.first;
      if (beforePw == password.value) {
        UserController.to.childrenControl.updateChildrenData(true, password: password.value);
        ToastUtils.show("青少年模式已开启");
        Get.until((route) => route.settings.name == AppRouter().indexRoute.name);
      } else {
        ToastUtils.show("两次密码输入不一致");
      }
    }
  }

  //修改提交
  _onChangeCommit() {
    if (pwModel.pwStep == ChildrenPwStep.step1) {
      if (password.value == UserController.to.childrenControl.childrenPw) {
        Get.toNamed(AppRouter().otherPages.childrenPwRoute.name,
            preventDuplicates: false,
            arguments: ChildrenPwModel(
                pwType: pwModel.pwType,
                pwStep: ChildrenPwStep.step2,
                stepPw: []));
      } else {
        ToastUtils.show("密码输入错误");
      }
    } else if (pwModel.pwStep == ChildrenPwStep.step2) {
      Get.toNamed(AppRouter().otherPages.childrenPwRoute.name,
          preventDuplicates: false,
          arguments: ChildrenPwModel(
              pwType: pwModel.pwType,
              pwStep: ChildrenPwStep.step3,
              stepPw: [password.value]));
    } else if (pwModel.pwStep == ChildrenPwStep.step3) {
      String? beforePw = pwModel.stepPw.first;
      if (beforePw == password.value) {
        UserController.to.childrenControl.updateChildrenData(true, password: password.value);
        ToastUtils.show("密码修改成功");
        Get.until((route) => route.settings.name == AppRouter().indexRoute.name);
      } else {
        ToastUtils.show("两次密码输入不一致");
      }
    }
  }

  //关闭提交
  _onCloseCommit() {
    if (pwModel.pwStep == ChildrenPwStep.step1) {
      if (password.value == UserController.to.childrenControl.childrenPw) {
        UserController.to.childrenControl.updateChildrenData(false);
        ToastUtils.show("青少年模式已关闭");
        Get.until((route) => route.settings.name == AppRouter().indexRoute.name);
      } else {
        ToastUtils.show("密码输入错误");
      }
    }
  }
}
