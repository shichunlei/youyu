import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';

class SettingPrivacyLogic extends AppBaseController {
  onSwitchDisturb(bool value) {
    UserController.to.setControl.isOpenDisturb.value = value;
  }

  onSwitchAddressBook(bool value) {
    UserController.to.setControl.isBookAddressHidden.value = value;
  }
}
