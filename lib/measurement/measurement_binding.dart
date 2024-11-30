import 'package:get/get.dart';

import 'measurement_logic.dart';

class MeasurementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MeasurementLogic());
  }
}
