import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/input/app_normal_input.dart';
import 'package:flutter/material.dart';

class LiveSettingTopWidget extends StatelessWidget {
  const LiveSettingTopWidget(
      {super.key,
      required this.title,
      required this.placeHolder,
      required this.controller,
      required this.onClick});

  final String title;
  final String placeHolder;
  final TextEditingController controller;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return AppColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      padding: EdgeInsets.only(top: 14.h),
      children: [
        Text(
          title,
          style: AppTheme().textStyle(
              fontSize: 14.sp, color: AppTheme.colorTextWhite),
        ),
        SizedBox(
          height: 13.h,
        ),
        InkWell(
          onTap: () {
            onClick();
          },
          child: AppNormalInput(
              enabled: false,
              radius: 99.w,
              controller: controller,
              textColor: AppTheme.colorTextWhite,
              placeHolderColor: AppTheme.colorTextSecond,
              backgroundColor: AppTheme.colorDarkLightBg,
              height: 40.h,
              placeHolder: placeHolder),
        ),
        SizedBox(
          height: 13.h,
        ),
        Container(height: 0.5, color: AppTheme.colorLine)
      ],
    );
  }
}
