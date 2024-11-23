import 'package:get/get.dart';

import 'conference_index_logic.dart';

class ConferenceIndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ConferenceIndexLogic());
  }
}
