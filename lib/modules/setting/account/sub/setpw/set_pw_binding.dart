import 'package:get/get.dart';

import 'set_pw_logic.dart';

class SetPwBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SetPwLogic());
  }
}
