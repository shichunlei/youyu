import 'package:get/get.dart';

import 'pay_logic.dart';

class PayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PayLogic());
  }
}
