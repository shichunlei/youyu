import 'package:get/get.dart';

import 'search_index_logic.dart';

class SearchIndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchIndexLogic());
  }
}
