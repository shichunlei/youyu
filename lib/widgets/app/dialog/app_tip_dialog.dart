import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///提示弹窗
class AppTipDialog {
  showTipDialog(String title, AppWidgetTheme theme,
      {String? msg,
      String? commitBtn,
      String? cancelBtn,
      Color? commitBtnColor,
      double? msgFontSize,
      bool onlyCommit = false,
      Function? onCancel,
      Function? onCommit,
      bool barrierDismissible = false,
      bool onWillPop = true,
      bool isAutoBack = true}) {
    Get.dialog(
        WillPopScope(
            child: Center(
              child: _TipDialog(
                title: title,
                theme: theme,
                msg: msg ?? "",
                commitBtn: commitBtn ?? "确定",
                cancelBtn: cancelBtn ?? "取消",
                commitBtnColor: commitBtnColor,
                onlyCommit: onlyCommit,
                msgFontSize: msgFontSize,
                bgColor: theme == AppWidgetTheme.light
                    ? const Color(0xFFFFFFFF)
                    : AppTheme.colorDarkBg,
                onCancel: () {
                  if (isAutoBack) {
                    Get.back();
                  }

                  if (onCancel != null) {
                    onCancel();
                  }
                },
                onCommit: () {
                  if (isAutoBack) {
                    Get.back();
                  }
                  if (onCommit != null) {
                    onCommit();
                  }
                },
              ),
            ),
            onWillPop: () async => onWillPop),
        barrierDismissible: barrierDismissible);
  }
}

class _TipDialog extends StatelessWidget {
  const _TipDialog({
    required this.title,
    required this.theme,
    required this.msg,
    required this.commitBtn,
    required this.cancelBtn,
    required this.onlyCommit,
    required this.bgColor,
    required this.onCommit,
    required this.onCancel,
    this.commitBtnColor,
    this.msgFontSize,
  });

  final AppWidgetTheme theme;
  final String title;
  final String msg;
  final String commitBtn;
  final String cancelBtn;
  final bool onlyCommit;
  final Color bgColor;
  final Function onCancel;
  final Function onCommit;
  final Color? commitBtnColor;
  final double? msgFontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 20.w, right: 20.w),
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(12.w)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //标题
          Container(
            margin: EdgeInsets.only(top: 20.h, left: 15.w, right: 15.w),
            child: Text(
              title,
              maxLines: 2,
              style: AppTheme().textStyle(
                  fontSize: 18,
                  color: theme == AppWidgetTheme.light
                      ? AppTheme.colorTextPrimary
                      : AppTheme.colorTextWhite),
            ),
          ),
          //内容
          if (msg.isNotEmpty)
            Container(
                margin: EdgeInsets.only(top: 12.h, left: 15.w, right: 15.w),
                child: Text(
                  msg,
                  maxLines: 5,
                  style: AppTheme().textStyle(
                      fontSize: msgFontSize ?? 18.sp,
                      color: theme == AppWidgetTheme.light
                          ? AppTheme.colorTextPrimary
                          : AppTheme.colorTextWhite),
                )),
          //按钮
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(
                left: 22.w, right: 22.w, top: 35.h, bottom: 20.h),
            child: onlyCommit ? _singleButton() : _doubleButton(),
          ),
        ],
      ),
    );
  }

  _singleButton() {
    return AppColorButton(
      title: commitBtn,
      width: 120.w,
      height: 44.h,
      titleColor: commitBtnColor ?? AppTheme.colorTextWhite,
      bgGradient: AppTheme().btnGradient,
      onClick: () {
        onCommit();
      },
    );
  }

  _doubleButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppColorButton(
          title: cancelBtn,
          width: 120.w,
          height: 44.h,
          titleColor: AppTheme.colorMain,
          borderColor: AppTheme.colorMain,
          bgColor: Colors.transparent,
          onClick: () {
            onCancel();
          },
        ),
        SizedBox(
          width: 20.w,
        ),
        AppColorButton(
          title: commitBtn,
          width: 120.w,
          height: 44.h,
          titleColor: commitBtnColor ?? AppTheme.colorTextWhite,
          bgGradient: AppTheme().btnGradient,
          onClick: () {
            onCommit();
          },
        ),
      ],
    );
  }
}
