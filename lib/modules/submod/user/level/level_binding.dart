import 'package:get/get.dart';

import 'level_logic.dart';

class LevelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LevelLogic());
  }
}
