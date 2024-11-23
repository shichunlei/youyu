import 'dart:math';
import 'package:youyu/utils/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///屏幕
class ScreenUtils {
  ScreenUtils._();

  /// 是否初始化
  static bool _isInit = false;

  /// 设计图宽度及高度
  static const double _uiWidth = 375, _uiHeight = 812;

  /// 屏幕宽度
  static double screenWidth = 0;

  /// 屏幕高度
  static double screenHeight = 0;

  /// 状态栏高度
  static double statusBarHeight = 0;

  /// 导航栏高度
  static double navbarHeight = 46;

  /// 底部安全高度高度
  static double safeBottomHeight = 0;

  /// 宽度缩放比例
  static double get _scaleWidth => screenWidth / _uiWidth;

  /// 高度缩放比例
  static double get _scaleHeight => screenHeight / _uiHeight;

  /// 缩放比例
  static double get _zoomScale {
    //设计搞宽高比 (越大越宽)
    const uiScale = _uiWidth / _uiHeight;
    //屏幕的宽高比 (越大越宽)
    final screenScale = screenWidth / screenHeight;

    final a = screenScale / uiScale;
    final b = uiScale / screenScale;
    final c = screenScale < uiScale ? min(a, b) : max(a, b);

    return c;
  }

  /// 屏幕适配初始化
  static void init(BuildContext context) {
    _isInit = true;
    if (screenWidth != 0 && statusBarHeight != 0) return;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    statusBarHeight = MediaQuery.of(context).padding.top;
    safeBottomHeight = MediaQuery.of(context).padding.bottom;
  }

  /// 获取适配宽度
  /// width 设计稿宽
  static double getAdaptWidth(double width) {
    assert(_isInit, 'ScreenUtils未初始化');
    /*
    _scaleWidth = 屏幕w/设计稿屏幕w
    x / width = _scaleWidth
    x = width * _scaleWidth
     */
    return width * _scaleWidth;
  }

  /// 获取适配高度
  /// height 设计稿高
  static double getAdaptHeight(double height) {
    assert(_isInit, 'ScreenUtils未初始化');
    /* _scaleHeight = (屏幕h/设计稿屏幕hh)
    y / height = _scaleHeight
    y = height * _scaleHeight
    最后 再 * 缩放比例
     */
    return height * _scaleHeight * _zoomScale;
  }

  ///适配图片高度
  /// width 代码设置的宽
  /// imageSize 图片的宽高
  static double getImageHeight(
      {required double width, required Size imageSize}) {
    /*
      代码h/代码w = 图片h/图片的w
      代码h = 代码w * 图片h/图片w
       */
    return width * imageSize.height / imageSize.width;
  }

  /// 获取适配字体大小
  static double getAdaptFontSize(double fontSize) {
    assert(_isInit, 'ScreenUtils未初始化');
    return fontSize * _scaleHeight * _zoomScale;
  }

  ///顶部状态栏透明（沉浸式）
  static void setTopTransparent() {
    if (PlatformUtils.isAndroid) {
      //顶部状态栏透明
      SystemUiOverlayStyle systemUiOverlayStyle =
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }
}

extension ScreenUtilsExtension on num {
  /// 获取适配宽度
  double get w => ScreenUtils.getAdaptWidth(toDouble()).toDouble();

  ///屏幕宽度的倍数
  ///Multiple of screen width
  double get sw => ScreenUtils.screenWidth * this;
  
  /// 获取适配高度
  double get h => ScreenUtils.getAdaptHeight(toDouble()).toDouble();

  /// 获取适配字体
  double get sp => ScreenUtils.getAdaptFontSize(toDouble()).toDouble();

  /// 获取图片的适配高度
  double imgHeight(Size imageSize) => this * imageSize.height / imageSize.width;
}
