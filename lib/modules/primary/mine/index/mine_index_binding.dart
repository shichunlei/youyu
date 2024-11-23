import 'package:get/get.dart';

import 'mine_index_logic.dart';

class MineIndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MineIndexLogic());
  }
}
