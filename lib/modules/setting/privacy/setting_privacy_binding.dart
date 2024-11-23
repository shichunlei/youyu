import 'package:get/get.dart';

import 'setting_privacy_logic.dart';

class SettingPrivacyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingPrivacyLogic());
  }
}
