// ignore_for_file: must_be_immutable

import 'package:youyu/utils/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:youyu/config/theme.dart';

///button 普通按钮
class AppColorButton extends StatelessWidget {
  const AppColorButton(
      {Key? key,
      required this.title,
      this.titleColor,
      this.bgGradient,
      this.bgColor,
      this.margin,
      this.padding,
      this.borderRadius,
      this.borderColor,
      this.fontSize,
      this.width,
      this.isAuto = false,
      this.height,
      this.onClick,
      this.alignment})
      : super(key: key);

  //宽高
  final double? width;
  final double? height;

  //margin & padding
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  //标题
  final String title;

  //标题颜色
  final Color? titleColor;

  //字体大小
  final double? fontSize;

  //背景颜色
  final Color? bgColor;

  //渐变
  final LinearGradient? bgGradient;

  //边框颜色 （固定1的宽度）
  final Color? borderColor;

  //圆角
  final BorderRadius? borderRadius;

  //是否自动布局
  final bool isAuto;

  final Alignment? alignment;

  //点击事件
  final Function? onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onClick != null) {
          onClick!();
        }
      },
      child: isAuto
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [_content()],
            )
          : _content(),
    );
  }

  _content() {
    return Container(
      alignment: alignment ?? Alignment.center,
      width: width,
      height: height,
      padding: padding ?? EdgeInsets.only(left: 18.w, right: 18.w),
      margin: margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
          color: bgColor,
          gradient: bgGradient,
          border: borderColor != null
              ? Border.all(
                  width: 1.w,
                  color: borderColor!,
                )
              : null,
          borderRadius: borderRadius ?? BorderRadius.circular(999.h)),
      child: isAuto
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [_text()],
            )
          : _text(),
    );
  }

  _text() {
    return Text(
      title,
      style: AppTheme().textStyle(
          color: titleColor ?? AppTheme.colorMain, fontSize: fontSize ?? 16.sp),
    );
  }
}
