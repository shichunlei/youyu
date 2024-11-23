import 'package:youyu/utils/tag_utils.dart';
import 'package:get/get.dart';

import 'phone_change_next_logic.dart';

class PhoneChangeNextBinding extends Bindings {
  @override
  void dependencies() {
    AppTapUtils.updateTag();
    Get.lazyPut(() => PhoneChangeNextLogic(),tag: AppTapUtils.tag);
  }
}
