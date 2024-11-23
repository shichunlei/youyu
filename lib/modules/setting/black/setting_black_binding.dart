import 'package:get/get.dart';

import 'setting_black_logic.dart';

class SettingBlackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingBlackLogic());
  }
}
