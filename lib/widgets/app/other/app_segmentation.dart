import 'package:flutter/material.dart';

///list view item 间隔
class AppSegmentation extends StatelessWidget {
  const AppSegmentation({Key? key, this.height, this.backgroundColor, this.width, this.margin})
      : super(key: key);

  final double? height;
  final double? width;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? margin;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width ?? double.infinity,
      height: height ?? 0,
      color: backgroundColor ?? Colors.transparent,
    );
  }
}
