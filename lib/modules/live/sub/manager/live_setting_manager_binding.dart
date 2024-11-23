import 'package:get/get.dart';

import 'live_setting_manager_logic.dart';

class LiveSettingManagerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LiveSettingManagerLogic());
  }
}
