import 'package:get/get.dart';

import 'friend_logic.dart';

class FriendBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FriendLogic());
  }
}
