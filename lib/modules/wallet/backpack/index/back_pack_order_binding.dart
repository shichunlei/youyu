import 'package:youyu/modules/wallet/backpack/index/back_pack_order_logic.dart';
import 'package:get/get.dart';

class BackPackOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BackPackOrderLogic());
  }
}
