import 'package:get/get.dart';

import 'children_logic.dart';

class ChildrenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChildrenLogic());
  }
}
