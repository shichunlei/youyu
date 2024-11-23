import 'package:get/get.dart';

import 'exchange_index_logic.dart';

class ExchangeIndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ExchangeIndexLogic());
  }
}
