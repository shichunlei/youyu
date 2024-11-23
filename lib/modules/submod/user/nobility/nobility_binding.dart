import 'package:get/get.dart';

import 'nobility_logic.dart';

class NobilityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NobilityLogic());
  }
}
