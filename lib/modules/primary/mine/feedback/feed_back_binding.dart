import 'package:get/get.dart';

import 'feed_back_logic.dart';

class FeedBackBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FeedBackLogic());
  }
}
