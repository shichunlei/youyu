import 'package:get/get.dart';

import 'common_gift_desc_logic.dart';

class CommonGiftDescBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CommonGiftDescLogic());
  }
}
