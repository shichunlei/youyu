import 'package:get/get.dart';

import 'report_logic.dart';

class ReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReportLogic());
  }
}
