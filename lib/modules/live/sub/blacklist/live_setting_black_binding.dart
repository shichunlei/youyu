import 'package:get/get.dart';

import 'live_setting_black_logic.dart';

class LiveSettingBlackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LiveSettingBlackLogic());
  }
}
