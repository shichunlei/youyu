import 'package:get/get.dart';

import 'real_auth_detail_logic.dart';

class RealAuthDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RealAuthDetailLogic());
  }
}
