
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/modules/setting/account/sub/changenext/model/phone_change_model.dart';
import 'package:get/get.dart';
import 'package:youyu/router/router.dart';

class PhoneChangeLogic extends AppBaseController {


  onChange() {
    //TODO:下一步
    Get.toNamed(AppRouter().settingPages.setPhoneChangeNextRoute.name,
        arguments: PhoneChangeModel(step: PhoneChangeStep.second, code: ""));
  }
}
