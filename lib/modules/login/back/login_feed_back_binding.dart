import 'package:get/get.dart';

import 'login_feed_back_logic.dart';

class LoginFeedBackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginFeedBackLogic());
  }
}
