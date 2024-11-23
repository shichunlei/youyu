import 'package:get/get.dart';

import 'live_setting_manager_search_logic.dart';

class LiveSettingManagerSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LiveSettingManagerSearchLogic());
  }
}
