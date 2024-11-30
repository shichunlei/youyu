import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/live/common/widget/float/live_global_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:youyu/router/router.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'base/base_controller.dart';

///悬浮管理
class FloatController extends AppBaseController {
  static FloatController get to => Get.find<FloatController>();

  ///测试悬浮
  testFloat() {
    return Positioned(
        right: 0,
        bottom: 200.h,
        child: GestureDetector(
          onTap: () {
            Get.toNamed(AppRouter().testRoute.name);
          },
          child: Container(
              width: 80.w,
              height: 40.h,
              color: AppTheme.colorMain,
              child: Center(
                child: Text(
                  '测试',
                  style: AppTheme().textStyle(),
                ),
              )),
        ));
  }

  liveFloat({required Widget child}) {
    return LiveGlobalView(
      child: child,
    );
  }
}
