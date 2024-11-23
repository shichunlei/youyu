import 'package:get/get.dart';

import 'pw_reset_logic.dart';

class PwResetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PwResetLogic());
  }
}
