import 'package:get/get.dart';

import 'login_index_logic.dart';

class LoginIndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginIndexLogic());
  }
}
