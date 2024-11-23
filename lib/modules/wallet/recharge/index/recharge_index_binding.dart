import 'package:get/get.dart';

import 'recharge_index_logic.dart';

class RechargeIndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RechargeIndexLogic());
  }
}
