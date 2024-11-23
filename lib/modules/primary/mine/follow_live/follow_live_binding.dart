import 'package:get/get.dart';

import 'follow_live_logic.dart';

class FollowLiveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FollowLiveLogic());
  }
}
