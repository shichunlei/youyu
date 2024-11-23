import 'package:get/get.dart';

import 'rank_index_logic.dart';

class RankIndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RankIndexLogic());
  }
}
