import 'package:get/get.dart';

import 'message_notification_logic.dart';

class MessageNotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MessageNotificationLogic());
  }
}
