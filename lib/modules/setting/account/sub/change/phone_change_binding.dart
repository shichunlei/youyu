import 'package:youyu/modules/setting/account/sub/change/phone_change_logic.dart';
import 'package:get/get.dart';

class PhoneChangeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PhoneChangeLogic());
  }
}
