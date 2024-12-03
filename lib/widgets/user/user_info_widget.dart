import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/other/app_gradient_text.dart';
import 'package:flutter/material.dart';

///用户昵称信息
class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget(
      {super.key,
      required this.isHighFancyNum,
      required this.name,
      this.sex,
      this.userType,
      this.nameFontSize});

  //是否显示靓号
  final bool isHighFancyNum;

  //昵称
  final String name;
  final double? nameFontSize;

  //性别 1男 2女
  final int? sex;

  //用户类型
  final String? userType;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ///靓号
        if (isHighFancyNum)
          AppLocalImage(
            path: AppResource().lh,
            width: 16.w,
          ),
        if (isHighFancyNum)
          SizedBox(
            width: 4.w,
          ),

        ///昵称
        _nickName(),

        ///性别
        if (sex != null)
          SizedBox(
            width: 4.w,
          ),
        if (sex != null) _sexWidget(),

        ///用户类型
        if (userType != null)
          SizedBox(
            width: 6.w,
          ),
        if (userType != null)
          AppColorButton(
            padding: EdgeInsets.zero,
            title: userType ?? "",
            width: 36.w,
            fontSize: 10.sp,
            height: 16.h,
            titleColor: const Color(0xFF000000),
            bgGradient: AppTheme().btnGradient,
          )
      ],
    );
  }

  ///昵称
  _nickName() {
    if (isHighFancyNum) {
      return Flexible(
          fit: FlexFit.loose,
          child: AppGradientText(
            name,
            textAlign: TextAlign.left,
            gradient: AppTheme().lhGradient,
            style: AppTheme().textStyle(
              fontSize: nameFontSize ?? 14.sp,
              color: AppTheme.colorTextDarkSecond,
              fontWeight: FontWeight.w700,
            ),
          ));
    } else {
      return Flexible(
        fit: FlexFit.loose,
        child: Text(
          name,
          style: AppTheme().textStyle(
            fontSize: nameFontSize ?? 14.sp,
            color: AppTheme.colorTextDarkSecond,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }
  }

  ///性别
  _sexWidget() {
    if (sex == 1) {
      return AppLocalImage(
        path: AppResource().boy,
        width: 11.w,
      );
    } else {
      return AppLocalImage(
        path: AppResource().girl,
        width: 11.w,
      );
    }
  }
}
