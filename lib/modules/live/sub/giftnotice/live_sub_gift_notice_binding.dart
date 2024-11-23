import 'package:get/get.dart';

import 'live_sub_gift_notice_logic.dart';

class LiveSubGiftNoticeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LiveSubGiftNoticeLogic());
  }
}
