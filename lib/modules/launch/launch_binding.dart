import 'package:get/get.dart';

import 'launch_logic.dart';

class LaunchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LaunchLogic());
  }
}
