import 'package:get/get.dart';

import 'with_draw_account_change_logic.dart';

class WithDrawAccountChangeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WithDrawAccountChangeLogic());
  }
}
