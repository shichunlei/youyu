import 'package:get/get.dart';

import 'with_draw_account_logic.dart';

class WithDrawAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WithDrawAccountLogic());
  }
}
