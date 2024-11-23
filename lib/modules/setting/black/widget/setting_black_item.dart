import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/widgets/user/user_info_widget.dart';
import 'package:youyu/widgets/user/user_tag_widget.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:flutter/material.dart';

class SettingBlackItem extends StatelessWidget {
  const SettingBlackItem(
      {super.key, required this.model, required this.onClickRemove});

  final UserInfo model;
  final Function onClickRemove;

  @override
  Widget build(BuildContext context) {
    return AppRow(
      crossAxisAlignment: CrossAxisAlignment.center,
      height: 86.h,
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      children: [
        AppCircleNetImage(
          imageUrl: model.avatar,
          size: 56.h,
          borderColor: AppTheme.colorTextWhite,
          borderWidth: 1.w,
        ),
        SizedBox(
          width: 8.w,
        ),
        Expanded(
            child: AppColumn(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserInfoWidget(
              isHighFancyNum: model.isHighFancyNum,
              name: model.nickname ?? "",
              sex: model.gender,
            ),
            SizedBox(
              height: 3.h,
            ),
            Text(
              "ID：${model.fancyNumber}",
              style: AppTheme().textStyle(
                  fontSize: 13.sp, color: AppTheme.colorTextSecond),
            ),
            SizedBox(
              height: 3.h,
            ),
            UserTagWidget(tagList: model.userTagList)
          ],
        )),
        AppColorButton(
          onClick: () {
            onClickRemove();
          },
          title: "移出",
          height: 26.h,
          titleColor: AppTheme.colorTextWhite,
          bgColor: AppTheme.colorRed,
          fontSize: 12.sp,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
        )
      ],
    );
  }
}
