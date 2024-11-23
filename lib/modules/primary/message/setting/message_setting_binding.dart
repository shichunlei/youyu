import 'package:get/get.dart';

import 'message_setting_logic.dart';

class MessageSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MessageSettingLogic());
  }
}
