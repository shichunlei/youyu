import 'package:get/get.dart';

import 'user_detail_logic.dart';

class UserDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserDetailLogic());
  }
}
