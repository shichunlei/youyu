import 'package:youyu/utils/screen_utils.dart';

import 'package:flutter/material.dart';
import 'package:youyu/config/theme.dart';

///未读红点
class AppUnReadIcon extends StatelessWidget {
  const AppUnReadIcon(
      {super.key,
      this.color,
      this.textColor,
      this.padding,
      required this.number,
      this.fontSize});

  final Color? color;
  final Color? textColor;
  final EdgeInsets? padding;
  final int number;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return number > 0
        ? Container(
            decoration: BoxDecoration(
                color: color ?? AppTheme.colorRed,
                borderRadius: BorderRadius.all(Radius.circular(99.w))),
            padding: padding ?? EdgeInsets.all(4.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _showNumber(),
                  style: AppTheme().textStyle(
                      fontSize: fontSize ?? 9.sp,
                      color: textColor ?? AppTheme.colorTextWhite,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          )
        : Container();
  }

  ///99+的规则
  _showNumber() {
    if (number > 99) {
      return "99+";
    } else {
      if (number < 10) {
        return " $number ";
      } else {
        return number.toString();
      }
    }
  }
}
