import 'package:youyu/utils/screen_utils.dart';
import 'package:flutter/material.dart';

///Container封装
class AppRoundContainer extends StatelessWidget {
  const AppRoundContainer(
      {super.key,
      this.height,
      this.padding,
      this.bgColor,
      this.border,
      this.borderRadius,
      this.gradient,
      required this.child,
      this.onTap,
      this.constraints,
      this.margin,
      this.width,
      this.alignment});

  //宽高
  final double? width;
  final double? height;

  //margin
  final EdgeInsets? margin;

  //padding (默认 EdgeInsets.only(left: 8.w, right: 8.w))
  final EdgeInsets? padding;

  //背景
  final Color? bgColor;

  //渐变
  final LinearGradient? gradient;

  //圆角 (默认圆型)
  final BorderRadiusGeometry? borderRadius;

  //边框
  final Border? border;

  //内容方向
  final Alignment? alignment;

  //约束
  final BoxConstraints? constraints;

  //子部件
  final Widget child;

  //点击事件
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          constraints: constraints,
          margin: margin,
          width: width,
          height: height,
          padding: padding ?? EdgeInsets.only(left: 8.w, right: 8.w),
          alignment: alignment,
          decoration: BoxDecoration(
              border: border,
              color: bgColor,
              borderRadius: borderRadius ?? BorderRadius.circular(999.h),
              gradient: gradient),
          child: child),
    );
  }
}
