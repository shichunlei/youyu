import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import 'package:youyu/utils/platform_utils.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';

enum AppWidgetTheme { light, dark }

class AppTheme {
  static AppTheme? _instance;

  factory AppTheme() => _instance ??= AppTheme._();

  AppTheme._();

  //主色
  static const Color colorMain = Color(0xFF7ADA54);

  //默认背景颜色
  static const Color colorBg = Color(0xFF090909);

  //背景颜色 深色
  static const Color colorDarkBg = Color(0xFF1E1E1E);

  //背景颜色 白色
  static const Color colorWhiteBg = Color(0xFFFFFFFF);

  //背景颜色 深浅色
  static const Color colorDarkLightBg = Color(0xFF3d3d3d);

  //导航栏颜色
  static const Color colorNavBar = Color(0xFF090909);

  //文字颜色1
  static const Color colorTextPrimary = Color(0xFF333333);

  //文字颜色2
  static const Color colorTextDark = Color(0xFF666666);

  //文字颜色3
  static const Color colorTextWhite = Color(0xFFFFFFFF);

  //文字颜色4
  static const Color colorTextSecond = Color(0xFF999999);

  //分割线1
  static const Color colorLine = Color(0xFF262626);

  //红色
  static const Color colorRed = Color(0xFFFF4949);

  //隐私政策
  static const Color colorPrivacy = Color(0xFF2FE9FE);

  static Color inputBg = const Color(0xFFCCCCCC).withOpacity(0.2);

  ///指示器
  AssetImage indicatorImage = AssetImage(AppResource().homeTabLine);

  ///文字样式
  TextStyle textStyle(
      {TextOverflow? overflow,
      Color? color,
      String? fontFamily,
      double? fontSize,
      FontStyle? fontStyle,
      double? height,
      TextDecoration? decoration,
      FontWeight? fontWeight}) {
    return TextStyle(
        overflow: overflow ?? TextOverflow.ellipsis,
        color: color ?? AppTheme.colorTextPrimary,
        fontSize: fontSize ?? 15.sp,
        fontStyle: fontStyle,
        height: height,
        fontFamily: fontFamily,
        decoration: decoration ?? TextDecoration.none,
        fontWeight: fontWeight ?? FontWeight.normal);
  }

  ///按钮渐变
  LinearGradient get btnGradient {
    return const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      stops: [0.0, 0.7],
      colors: [Color(0xFF3FFEDC), Color(0xFF34FF8F)],
    );
  }

  LinearGradient get btnLightGradient {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [0.0, 1.0],
      colors: [Color(0xFFDCDCDC), Color(0xFFDCDCDC)],
    );
  }

  ///商城按钮渐变
  LinearGradient get shopBtnGradient {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [0.0, 1.0],
      colors: [Color(0xFF612ADA), Color(0xFF8B61E8)],
    );
  }

  ///首页tab渐变
  LinearGradient get homeTabGradient {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [0.0, 1.0],
      colors: [Color(0x4DC9EB58), Color(0x4D8ACD4E)],
    );
  }

  ///遮罩渐变
  LinearGradient get maskGradient {
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.0, 1.0],
      colors: [Color(0x00000000), Color(0x4D000000)],
    );
  }

  LinearGradient get maskReverseGradient {
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.0, 1.0],
      colors: [Color(0x4D000000), Color(0x00000000)],
    );
  }

  ///vip相关渐变
  LinearGradient get vipGradient {
    return const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      stops: [0.0, 1.0],
      colors: [Color(0xFFF1E6D7), Color(0xFFE0B6A6)],
    );
  }

  ///靓号相关渐变
  LinearGradient get lhGradient {
    return const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      stops: [0.0, 1.0],
      colors: [Color(0xFFFFCC00), Color(0xFFFE7E5B)],
    );
  }

  ///直播间默认渐变背景
  LinearGradient get liveDBgGradient {
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.0, 1.0],
      colors: [Color(0xFF00322D), Color(0xFF000607)],
    );
  }

  ///直播间管理标签渐变
  LinearGradient get liveManagerGradient {
    return const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      stops: [0.0, 1.0],
      colors: [Color(0xFF75C6F8), Color(0xFF5B9EFE)],
    );
  }

  ///输入框
  InputDecoration inputDecoration(
      {String? hintText,
      double? hintSize,
      Color? hintColor,
      Widget? counter,
      TextStyle? counterStyle,
      TextStyle? suffixStyle}) {
    return InputDecoration(
        counter: counter,
        isCollapsed: true,
        hintText: hintText,
        contentPadding: const EdgeInsets.all(0),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        suffixStyle: suffixStyle,
        counterStyle: counterStyle,
        hintStyle: textStyle(fontSize: hintSize, color: hintColor));
  }

  ///键盘的inputView
  KeyboardActionsConfig keyboardActions(List<KeyboardActionsItem> actions) {
    if (PlatformUtils.isAndroid) {
      //TODO:只ios添加
      actions.clear();
    }
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: actions,
    );
  }

  KeyboardActionsItem keyboardActionItem(FocusNode focusNode, {String? title}) {
    return KeyboardActionsItem(
      focusNode: focusNode,
      toolbarButtons: [
        (node) {
          return GestureDetector(
            onTap: () => node.unfocus(),
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title ?? "完成",
                style: textStyle(fontSize: 15.sp),
              ),
            ),
          );
        }
      ],
    );
  }

  ///默认头像
  Image defaultHeadImage({double? width, double? height}) {
    return Image(
      image: AssetImage(AppResource().defaultHead),
      width: width,
      height: height,
    );
  }

  ///默认图片
  defaultImage({double? width, double? height, Color? color, double? radius}) {
    return AppContainer(
      radius: radius ?? 1.w,
      color: color ?? const Color(0xFF1E1E1E),
      width: width,
      height: height,
    );
  }

  defaultNewImage(
      {double? width, double? height, Color? color, double? radius}) {
    return AppContainer(
      radius: radius ?? 1.w,
      color: color ?? const Color(0xFF1E1E1E),
      width: double.infinity,
      height: double.infinity,
    );
  }
}
