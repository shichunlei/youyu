import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:flutter/material.dart';

class LiveSettingManagerItem extends StatelessWidget {
  const LiveSettingManagerItem(
      {super.key,
      required this.model,
      required this.onCancelManager,
      required this.onSetManager});

  final UserInfo model;
  final Function(UserInfo model) onCancelManager;
  final Function(UserInfo model) onSetManager;

  @override
  Widget build(BuildContext context) {
    return AppRow(
      radius: 8.w,
      color: AppTheme.colorDarkBg,
      margin: EdgeInsets.symmetric(horizontal: 14.w),
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 14.h),
      children: [
        AppNetImage(
          imageUrl: model.avatar,
          fit: BoxFit.cover,
          width: 50.w,
          height: 50.w,
        ),
        SizedBox(
          width: 8.w,
        ),
        Expanded(
            child: AppColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.nickname ?? "",
              style: AppTheme().textStyle(
                  fontSize: 16.sp, color: AppTheme.colorTextWhite),
            ),
            SizedBox(
              height: 4.h,
            ),
            Text(
              "ID:${model.fancyNumber}",
              style: AppTheme().textStyle(
                  fontSize: 13.sp, color: AppTheme.colorTextSecond),
            ),
          ],
        )),
        model.isManage == 1
            ? AppColorButton(
                onClick: () {
                  onCancelManager(model);
                },
                title: "取消管理",
                titleColor: AppTheme.colorTextWhite,
                bgColor: const Color(0xFFDADADA),
                fontSize: 12.sp,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
              )
            : AppColorButton(
                onClick: () {
                  onSetManager(model);
                },
                title: "设置管理",
                titleColor: AppTheme.colorTextWhite,
                bgGradient: AppTheme().btnGradient,
                fontSize: 12.sp,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
              )
      ],
    );
  }
}
