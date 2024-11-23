import 'package:get/get.dart';

import 'user_image_manager_logic.dart';

class UserImageManagerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserImageManagerLogic());
  }
}
