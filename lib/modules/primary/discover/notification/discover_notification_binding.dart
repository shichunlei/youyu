import 'package:get/get.dart';

import 'discover_notification_logic.dart';

class DiscoverNotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DiscoverNotificationLogic());
  }
}
