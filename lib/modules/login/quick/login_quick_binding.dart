import 'package:get/get.dart';

import 'login_quick_logic.dart';

class LoginQuickBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginQuickLogic());
  }
}
