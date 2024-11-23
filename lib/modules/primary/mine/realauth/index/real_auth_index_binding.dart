import 'package:get/get.dart';

import 'real_auth_index_logic.dart';

class RealAuthIndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RealAuthIndexLogic());
  }
}
