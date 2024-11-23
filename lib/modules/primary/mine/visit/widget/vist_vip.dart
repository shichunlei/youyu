import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';

class VisitVip extends StatelessWidget {
  const VisitVip({super.key, required this.onClick});
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return AppRow(
      crossAxisAlignment: CrossAxisAlignment.center,
      padding: EdgeInsets.only(left: 18.w, right: 5.w),
      height: 40.h,
      color: const Color(0xFF1B1B2D),
      margin: EdgeInsets.only(top: 15.h),
      radius: 99.h,
      children: [
        AppLocalImage(
          path: AppResource().mineVipLeft,
          height: 21.h,
        ),
        SizedBox(width: 10.w,),
        Expanded(
          child: Text(
            "开通VIP可查看所有访客记录",
            style: AppTheme().textStyle(
                fontSize: 14.sp, color: AppTheme.colorTextWhite),
          ),
        ),
        AppColorButton(
          onClick: onClick,
          title: "立即开通",
          height: 32.h,
          borderRadius: BorderRadius.all(Radius.circular(99.w)),
          fontSize: 12.sp,
          alignment: Alignment.center,
          titleColor: AppTheme.colorTextPrimary,
          padding: EdgeInsets.only(left: 8.w, right: 8.w),
          bgGradient: AppTheme().vipGradient,
        )
      ],
    );
  }
}
