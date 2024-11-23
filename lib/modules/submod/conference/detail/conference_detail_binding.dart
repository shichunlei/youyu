import 'package:get/get.dart';

import 'conference_detail_logic.dart';

class ConferenceDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ConferenceDetailLogic());
  }
}
