import 'package:get/get.dart';

import 'discover_index_logic.dart';

class DiscoverIndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DiscoverIndexLogic());
  }
}
