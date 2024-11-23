import 'package:get/get.dart';

import 'visit_logic.dart';

class VisitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VisitLogic());
  }
}
