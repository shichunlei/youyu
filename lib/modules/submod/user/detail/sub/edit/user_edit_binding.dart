import 'package:get/get.dart';

import 'user_edit_logic.dart';

class UserEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserEditLogic());
  }
}
