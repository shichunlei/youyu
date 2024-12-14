import 'package:get/get.dart';

import 'message_remark_logic.dart';

class MessageRemarkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MessageRemarkLogic());
  }
}
