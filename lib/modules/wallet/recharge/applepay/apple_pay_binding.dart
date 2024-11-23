import 'package:get/get.dart';

import 'apple_pay_logic.dart';

class ApplePayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApplePayLogic());
  }
}
