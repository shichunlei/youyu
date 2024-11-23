import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
///房间解锁
class LiveSettingUnLockDialog extends StatelessWidget {
  const LiveSettingUnLockDialog(
      {super.key,
      required this.title,
      required this.msg});

  final String title;
  final String msg;

  @override
  Widget build(BuildContext context) {
    return AppColumn(
      width: double.infinity,
      radius: 12.w,
      color: AppTheme.colorDarkBg,
      margin: EdgeInsets.only(left: 20.w, right: 20.w),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //标题
        Container(
          margin: EdgeInsets.only(top: 15.h, left: 15.w, right: 15.w),
          child: Text(
            title,
            maxLines: 2,
            style: AppTheme().textStyle(fontSize: 16, color: AppTheme.colorTextWhite),
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
                    fontSize: 14, color: AppTheme.colorTextSecond),
              )),
        //按钮
        Container(
          alignment: Alignment.bottomCenter,
          margin:
              EdgeInsets.only(left: 22.w, right: 22.w, top: 35.h, bottom: 20.h),
          child: _doubleButton(),
        ),
      ],
    );
  }

  _doubleButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppColorButton(
          title: "确认",
          width: 120.w,
          height: 44.h,
          titleColor: AppTheme.colorTextWhite,
          bgGradient: AppTheme().btnGradient,
          onClick: () {
            Get.back(result: true);
          },
        ),
        SizedBox(
          width: 20.w,
        ),
        AppColorButton(
          title: "取消",
          width: 120.w,
          height: 44.h,
          titleColor: AppTheme.colorMain,
          borderColor: AppTheme.colorMain,
          onClick: () {
            Get.back(result: false);
          },
        ),
      ],
    );
  }
}
