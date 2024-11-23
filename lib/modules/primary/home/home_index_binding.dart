import 'package:get/get.dart';

import 'home_index_logic.dart';

class HomeIndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeIndexLogic());
  }
}
