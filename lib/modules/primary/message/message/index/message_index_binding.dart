import 'package:get/get.dart';

import 'message_index_logic.dart';

class MessageIndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MessageIndexLogic());
  }
}
