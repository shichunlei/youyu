import 'package:get/get.dart';

import 'login_info_logic.dart';

class LoginInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginInfoLogic());
  }
}
