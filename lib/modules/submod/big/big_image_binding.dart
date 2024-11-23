import 'package:get/get.dart';

import 'big_image_logic.dart';

class BigImageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BigImageLogic());
  }
}
