import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:flutter/material.dart';

class LiveSettingBlackItem extends StatelessWidget {
  const LiveSettingBlackItem(
      {super.key,
      required this.model,
      required this.type,
      required this.onClickRemove});

  final UserInfo model;
  final int type;
  final Function onClickRemove;

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
        AppColorButton(
          onClick: () {
            onClickRemove();
          },
          title: type == 1 ? "取消禁言" : "移除",
          borderColor: const Color(0xffC9EB58),
          titleColor: AppTheme.colorMain,
          bgGradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 1.0],
            colors: [Color(0x33C9EB58), Color(0x338ACD4E)],
          ),
          fontSize: 12.sp,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
        )
      ],
    );
  }
}
