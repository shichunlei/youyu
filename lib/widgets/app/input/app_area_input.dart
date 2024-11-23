import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:flutter/material.dart';

///多行输入
class AppAreaInput extends StatefulWidget {
  const AppAreaInput(
      {Key? key,
      required this.theme,
      required this.height,
      required this.placeHolder,
      this.enabled = true,
      this.placeHolderColor,
      this.textColor,
      this.onChanged,
      this.maxLength,
      this.controller,
      this.fontSize,
      this.padding,
      this.focusNode,
      this.radius,
      this.counterStyle,
      this.bgColor,
      this.onSubmitted,
      this.textInputAction})
      : super(key: key);

  //主题
  final AppWidgetTheme theme;

  final Color? bgColor;

  //占位颜色
  final Color? placeHolderColor;

  //文字颜色
  final Color? textColor;

  //是否可以输入
  final bool enabled;

  //左边间距
  final EdgeInsets? padding;

  //圆角
  final double? radius;

  final double? fontSize;

  //高度
  final double height;

  //占位语
  final String placeHolder;

  //监听文字变化
  final ValueChanged<String>? onChanged;

  //最多长度
  final int? maxLength;

  final FocusNode? focusNode;

  //控制器
  final TextEditingController? controller;

  final TextStyle? counterStyle;

  final ValueChanged<String>? onSubmitted;

  final TextInputAction? textInputAction;

  @override
  State<AppAreaInput> createState() => _AppAreaInputState();
}

class _AppAreaInputState extends State<AppAreaInput> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      padding: widget.padding ??
          EdgeInsets.only(left: 15.w, right: 15.w, top: 12.w, bottom: 12.w),
      decoration: BoxDecoration(
        color: widget.bgColor ??
            (widget.theme == AppWidgetTheme.light
                ? const Color(0xFFFFFFFF)
                : AppTheme.colorDarkBg),
        borderRadius: BorderRadius.circular((widget.radius ?? 6.w)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: TextField(
                  textInputAction: widget.textInputAction,
                  enabled: widget.enabled,
                  focusNode: widget.focusNode,
                  cursorColor: AppTheme.colorMain,
                  controller: widget.controller,
                  onChanged: (str) {
                    if (widget.onChanged != null) {
                      widget.onChanged!(str);
                    }
                  },
                  onSubmitted: widget.onSubmitted,
                  maxLength: widget.maxLength,

                  maxLines: 1000,
                  style: AppTheme().textStyle(
                      fontSize: widget.fontSize ?? 15.sp,
                      color: widget.textColor),
                  decoration: AppTheme().inputDecoration(
                        hintText: widget.placeHolder,
                        counterStyle: widget.counterStyle,
                        hintSize: widget.fontSize ?? 15.sp,
                        hintColor: widget.placeHolderColor ??
                            const Color(0xFF9CA3AF),
                      ))),
          SizedBox(
            width: 5.h,
          ),
        ],
      ),
    );
  }
}
