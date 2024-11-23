// ignore_for_file: must_be_immutable

import 'package:youyu/utils/screen_utils.dart';
import 'package:flutter/material.dart';

///清除按钮
class AppClearIcon extends StatelessWidget {
  AppClearIcon(
      {Key? key,
      required this.backgroundColor,
      this.text,
      this.isMarginRight = false})
      : super(key: key);

  final Color backgroundColor;
  String? text;
  bool isMarginRight;

  @override
  Widget build(BuildContext context) {
    if ((text ?? "").isNotEmpty) {
      return Container(
        width: 20.w,
        height: 20.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: const Color(0xFFD8D8D8),
            borderRadius: BorderRadius.circular(30)),
        margin: EdgeInsets.only(left: 10.w, right: isMarginRight ? 8 : 0),
        child: Icon(
          size: 20,
          Icons.clear,
          color: backgroundColor,
        ),
      );
    } else {
      return Container();
    } //清除按钮
  }
}
