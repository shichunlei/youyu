import 'package:youyu/modules/live/common/widget/float/live_global_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'base/base_controller.dart';

///悬浮管理
class FloatController extends AppBaseController {
  static FloatController get to => Get.find<FloatController>();

  liveFloat({required Widget child}) {
    return LiveGlobalView(
      child: child,
    );
  }
}
