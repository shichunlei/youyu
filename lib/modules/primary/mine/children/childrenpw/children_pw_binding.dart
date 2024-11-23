import 'package:youyu/utils/tag_utils.dart';
import 'package:get/get.dart';

import 'children_pw_logic.dart';

class ChildrenPwBinding extends Bindings {
  @override
  void dependencies() {
    AppTapUtils.updateTag();
    Get.lazyPut(() => ChildrenPwLogic(),tag: AppTapUtils.tag);
  }
}
