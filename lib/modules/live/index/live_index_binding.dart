import 'package:youyu/utils/tag_utils.dart';
import 'package:get/get.dart';

import 'live_index_logic.dart';

class LiveIndexBinding extends Bindings {
  @override
  void dependencies() {
    AppTapUtils.updateTag();
    Get.lazyPut(() => LiveIndexLogic(),tag: AppTapUtils.tag);
  }
}
