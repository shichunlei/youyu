// ignore_for_file: must_be_immutable

import 'dart:async';
import 'package:youyu/utils/log_utils.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:youyu/config/theme.dart';

///手机验证码输入框
class AppVerifyInput extends StatefulWidget {
  AppVerifyInput(
      {Key? key,
      required this.height,
      this.backgroundColor,
      this.placeHolderColor,
      this.textColor,
      this.onChanged,
      this.maxLength,
      this.onClickVerify,
      this.focusNode,
      this.fontSize,
      this.padding,
      this.countDownFontSize,
      required this.placeHolder,
      this.controller,
      this.radius,
      this.verifyTextColor})
      : super(key: key);

  //背景颜色
  Color? backgroundColor;

  //占位颜色
  Color? placeHolderColor;

  //文字颜色
  Color? textColor;

  //圆角
  double? radius;

  double? padding;

  //高度
  final double height;
  double? fontSize;
  double? countDownFontSize;

  //占位语
  final String placeHolder;

  //监听文字变化
  final ValueChanged<String>? onChanged;

  //点击验证码
  final Function()? onClickVerify;

  //最多长度
  int? maxLength;

  //控制器
  TextEditingController? controller;

  final FocusNode? focusNode;

  //获取验证码文案颜色
  final Color? verifyTextColor;

  @override
  State<AppVerifyInput> createState() => AppVerifyInputState();
}

class AppVerifyInputState extends State<AppVerifyInput>
    with AutomaticKeepAliveClientMixin {
  //倒计时总时长
  int _countdownTime = 60;

  //是否在倒计时中
  bool _yzmcgrc = false;

  //定时器
  Timer? _timer;

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular((widget.radius ?? 6.w))),
      ),
      height: widget.height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Expanded(child: _editWidget()), _btnWidget()],
      ),
    );
  }

  ///输入框
  Widget _editWidget() {
    return SizedBox(
      height: widget.height,
      child: Row(
        children: [
          SizedBox(
            width: widget.padding ?? 15.w,
          ),
          Expanded(
              child: TextField(
            focusNode: widget.focusNode,
            cursorColor: AppTheme.colorMain,
            controller: widget.controller,
            onChanged: (str) {
              if (widget.onChanged != null) {
                widget.onChanged!(str);
              }
              setState(() {});
            },
            keyboardType: TextInputType.number,
            maxLength: widget.maxLength,
            maxLines: 1,
            style: AppTheme().textStyle(
                fontSize: widget.fontSize ?? 15.sp, color: widget.textColor),
            decoration: AppTheme().inputDecoration(
                hintText: widget.placeHolder,
                hintSize: widget.fontSize ?? 15.sp,
                hintColor: widget.placeHolderColor ??
                    const Color(0xFF9CA3AF)),
          )),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  ///按钮
  Widget _btnWidget() {
    return InkWell(
      onTap: () {
        if (!_yzmcgrc) {
          if (widget.onClickVerify != null) {
            widget.onClickVerify!();
          }
        }
      },
      child: Container(
        padding: EdgeInsets.only(right: widget.padding ?? 15.w),
        alignment: Alignment.centerLeft,
        child: RichText(
            text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                style: AppTheme().textStyle(
                    color: _yzmcgrc
                        ? (widget.verifyTextColor ??
                        const Color(0xFF9CA3AF))
                        : AppTheme.colorMain,
                    fontSize: widget.countDownFontSize ?? 15.sp),
                text: "获取验证码"),
            if (_yzmcgrc)
              TextSpan(
                style: AppTheme().textStyle(
                    color: (widget.verifyTextColor ??
                        const Color(0xFF9CA3AF)),
                    fontSize: widget.countDownFontSize ?? 15.sp),
                text: "(",
              ),
            if (_yzmcgrc)
              TextSpan(
                style: AppTheme().textStyle(
                    color: AppTheme.colorRed,
                    fontSize: widget.countDownFontSize ?? 15.sp),
                text: "${_countdownTime.toString()}s",
              ),
            if (_yzmcgrc)
              TextSpan(
                style: AppTheme().textStyle(
                    color: (widget.verifyTextColor ??
                        const Color(0xFF9CA3AF)),
                    fontSize: widget.countDownFontSize ?? 15.sp),
                text: ")",
              ),
          ],
        )),
      ),
    );
  }

  ///点击发送
  void countdownTimerEvent() {
    callback(timer) => {
          setState(() {
            if (_countdownTime <= 0) {
              cancelTimer();
            } else {
              _yzmcgrc = true;
              _countdownTime--;
            }
            LogUtils.onPrint(_countdownTime);
          })
        };
    _timer = Timer.periodic(const Duration(seconds: 1), callback);
  }

  ///取消倒计时
  void cancelTimer() {
    if (_timer != null) {
      _timer?.cancel();
    }
    _yzmcgrc = false;
    _countdownTime = 60;
  }

  @override
  bool get wantKeepAlive => true;
}
