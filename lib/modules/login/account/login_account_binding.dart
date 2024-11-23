import 'package:get/get.dart';

import 'login_account_logic.dart';

class LoginAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginAccountLogic());
  }
}
