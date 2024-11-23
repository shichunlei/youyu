import 'package:get/get.dart';

import 'bag_logic.dart';

class BagBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BagLogic());
  }
}
