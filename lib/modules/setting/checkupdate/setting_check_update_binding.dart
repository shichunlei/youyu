import 'package:get/get.dart';

import 'setting_check_update_logic.dart';

class SettingCheckUpdateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingCheckUpdateLogic());
  }
}
