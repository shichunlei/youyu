import 'package:get/get.dart';

import 'discover_detail_logic.dart';

class DiscoverDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DiscoverDetailLogic());
  }
}
