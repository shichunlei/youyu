import 'package:get/get.dart';

import 'user_edit_sub_logic.dart';

class UserEditSubBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserEditSubLogic());
  }
}
