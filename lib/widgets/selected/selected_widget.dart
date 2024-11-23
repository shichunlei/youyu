// ignore_for_file: must_be_immutable

import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';

///选择框
class SelectedWidget extends StatefulWidget {
  SelectedWidget(
      {Key? key,
      required this.height,
      required this.placeHolder,
      required this.onClick,
      this.backgroundColor,
      this.placeHolderColor,
      this.textColor,
      this.fontSize,
      this.controller,
      this.paddingLeft,
      this.radius})
      : super(key: key);

  //背景颜色
  Color? backgroundColor;

  //占位颜色
  Color? placeHolderColor;

  //文字颜色
  Color? textColor;

  //左边间距
  double? paddingLeft;

  //圆角
  double? radius;

  //高度
  final double height;

  //占位语
  final String placeHolder;

  double? fontSize;

  //控制器
  TextEditingController? controller;

  final Function onClick;

  @override
  State<SelectedWidget> createState() => _SelectedWidgetState();
}

class _SelectedWidgetState extends State<SelectedWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onClick();
      },
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular((widget.radius ?? 6.w)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: widget.paddingLeft ?? 15.w,
            ),
            Expanded(
                child: TextField(
              enabled: false,
              cursorColor: AppTheme.colorMain,
              controller: widget.controller,
              maxLines: 1,
              style: AppTheme().textStyle(
                  fontSize: widget.fontSize ?? 15.sp, color: widget.textColor),
              decoration: AppTheme().inputDecoration(
                  hintText: widget.placeHolder,
                  hintSize: widget.fontSize ?? 15.sp,
                  hintColor: widget.placeHolderColor ??
                      const Color(0xFF9CA3AF)),
            )),
            AppLocalImage(
              path: AppResource().down,
              width: 14.w,
            ),
            SizedBox(
              width: widget.paddingLeft ?? 15.w,
            ),
          ],
        ),
      ),
    );
  }
}
