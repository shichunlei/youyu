import 'package:get/get.dart';

import 'with_draw_account_add_logic.dart';

class WithDrawAccountAddBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WithDrawAccountAddLogic());
  }
}
