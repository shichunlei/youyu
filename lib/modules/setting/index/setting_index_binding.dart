import 'package:get/get.dart';

import 'setting_index_logic.dart';

class SettingIndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingIndexLogic());
  }
}
