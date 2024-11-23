import 'package:get/get.dart';

import 'setting_write_off_logic.dart';

class SettingWriteOffBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingWriteOffLogic());
  }
}
