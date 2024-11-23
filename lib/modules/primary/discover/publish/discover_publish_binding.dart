import 'package:get/get.dart';

import 'discover_publish_logic.dart';

class DiscoverPublishBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DiscoverPublishLogic());
  }
}
