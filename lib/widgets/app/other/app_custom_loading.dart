import 'package:youyu/utils/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
///自定义loading（消息页面使用）
class AppCustomLoading {
  static Future<void> showLoading([String? status]) async {
    await EasyLoading.show(
      status: status,
      maskType: EasyLoadingMaskType.black,
      indicator: Builder(builder: (context) {
        return LoadingAnimationWidget.dotsTriangle(
          color: Theme.of(context).primaryColor,
          size: 38.w,
        );
      }),
    );
  }

  static Future<void> showLiteLoading([String? status]) async {
    await EasyLoading.show(
      status: status,
      maskType: EasyLoadingMaskType.clear,
      indicator: Builder(builder: (context) {
        return LoadingAnimationWidget.waveDots(
          color: Colors.white,
          size: 20.w,
        );
      }),
    );
  }

  static Future<void> hideLoading() async {
    await EasyLoading.dismiss();
  }
}
