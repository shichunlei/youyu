import 'package:get/get.dart';

import 'search_sub_logic.dart';

class SearchSubBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchSubLogic());
  }
}
