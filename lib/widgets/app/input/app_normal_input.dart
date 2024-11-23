// ignore_for_file: must_be_immutable

import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///普通输入框
class AppNormalInput extends StatefulWidget {
  const AppNormalInput(
      {Key? key,
      required this.height,
      required this.placeHolder,
      this.backgroundColor,
      this.enabled = true,
      this.placeHolderColor,
      this.textColor,
      this.onChanged,
      this.inputFormatters,
      this.maxLength,
      this.keyboardType,
      this.isShowEye = false,
      this.fontSize,
      this.controller,
      this.onClickEye,
      this.paddingLeft,
      this.paddingRight,
      this.focusNode,
      this.radius,
      this.autofocus = false,
      this.onSubmitted,
      this.textAlign,
      this.counter,
      this.eyeColor,
      this.textInputAction})
      : super(key: key);

  //背景颜色
  final Color? backgroundColor;

  //占位颜色
  final Color? placeHolderColor;

  //文字颜色
  final Color? textColor;

  //是否可以输入
  final bool enabled;

  //左边间距
  final double? paddingLeft;

  //右边边间距
  final double? paddingRight;

  //圆角
  final double? radius;

  //高度
  final double height;

  //占位语
  final String placeHolder;

  //监听文字变化
  final ValueChanged<String>? onChanged;

  //点击密码
  final Function(bool isShow)? onClickEye;

  //拦截
  final List<TextInputFormatter>? inputFormatters;

  //是否显示眼睛
  final bool isShowEye;

  //最多长度
  final int? maxLength;

  final double? fontSize;

  //键盘类型
  final TextInputType? keyboardType;

  final TextAlign? textAlign;

  final FocusNode? focusNode;

  final bool autofocus;

  final ValueChanged<String>? onSubmitted;

  //控制器
  final TextEditingController? controller;

  final Widget? counter;

  //眼睛的颜色
  final Color? eyeColor;

  final TextInputAction? textInputAction;

  @override
  State<AppNormalInput> createState() => _AppNormalInputState();
}

class _AppNormalInputState extends State<AppNormalInput> {
  bool obscureText = false;

  @override
  void initState() {
    super.initState();
    if (widget.isShowEye) {
      obscureText = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            textAlign: widget.textAlign ?? TextAlign.start,
            onSubmitted: widget.onSubmitted,
            autofocus: widget.autofocus,
            enabled: widget.enabled,
            focusNode: widget.focusNode,
            cursorColor: AppTheme.colorMain,
            controller: widget.controller,
            onChanged: (str) {
              if (widget.onChanged != null) {
                widget.onChanged!(str);
              }
            },
            maxLength: widget.maxLength,
            obscureText: obscureText,
            maxLines: 1,
            inputFormatters: widget.inputFormatters,
            keyboardType: widget.keyboardType ?? TextInputType.text,
            textInputAction: widget.textInputAction,
            style: AppTheme().textStyle(
                fontSize: widget.fontSize ?? 15.sp, color: widget.textColor),
            decoration: AppTheme().inputDecoration(
                counter: widget.counter,
                hintText: widget.placeHolder,
                hintSize: widget.fontSize ?? 15.sp,
                hintColor: widget.placeHolderColor ??
                    const Color(0xFF9CA3AF)),
          )),
          _passWord(),
          SizedBox(
            width: widget.paddingRight ?? 10.w,
          ),
        ],
      ),
    );
  }

  Widget _passWord() {
    if (widget.isShowEye) {
      return AppContainer(
        onTap: () {
          setState(() {
            obscureText = !obscureText;
            if (widget.onClickEye != null) {
              widget.onClickEye!(obscureText);
            }
          });
        },
        color: widget.backgroundColor,
        padding: EdgeInsets.only(right: 5.w),
        child: Center(
          child: obscureText
              ? Icon(
                  Icons.visibility_off,
                  size: 20.w,
                  color: widget.eyeColor ?? AppTheme.colorTextDark,
                )
              : Icon(
                  size: 20.w,
                  Icons.visibility,
                  color: widget.eyeColor ?? AppTheme.colorTextDark,
                ),
        ),
      );
    } else {
      return Container();
    }
  }
}
