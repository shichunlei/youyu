import 'package:get/get.dart';

import 'record_index_logic.dart';

class RecordIndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RecordIndexLogic());
  }
}
