import 'package:youyu/controllers/app_controller.dart';
import 'package:youyu/controllers/base/base_controller.dart';

class SettingCheckUpdateLogic extends AppBaseController {
  onCheckVersion() {
    AppController.to.enterCheckVersion(isShowToast: true);
  }
}
