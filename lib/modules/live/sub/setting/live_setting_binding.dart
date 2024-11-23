import 'package:get/get.dart';

import 'live_setting_logic.dart';

class LiveSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LiveSettingLogic());
  }
}
