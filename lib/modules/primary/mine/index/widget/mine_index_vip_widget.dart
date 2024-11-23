import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/other/app_gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
///vip banner
class MineIndexVipWidget extends StatelessWidget {
  late final double imageW;
  late final double imageH;
  final Function onClickOpen;

  MineIndexVipWidget({super.key, required this.onClickOpen}) {
    imageW = (ScreenUtils.screenWidth - 60.w);
    imageH = imageW.imgHeight(const Size(314, 44.4));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          width: imageW,
          height: imageH,
          margin: EdgeInsets.only(top: 15.h),
          padding: EdgeInsets.only(left: 22.w, right: 7.w),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AppResource().mineVipBanner),
                  fit: BoxFit.fitHeight)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _leftWidget()),
              if (!UserController.to.isVip)
                AppColorButton(
                  onClick: () {
                    onClickOpen();
                  },
                  title: "立即开通",
                  height: imageH - 12.h,
                  borderRadius: BorderRadius.all(Radius.circular(99.w)),
                  fontSize: 12.sp,
                  alignment: Alignment.center,
                  titleColor: AppTheme.colorTextPrimary,
                  padding: EdgeInsets.only(left: 8.w, right: 8.w),
                  bgGradient: AppTheme().vipGradient,
                )
            ],
          ),
        ));
  }

  _leftWidget() {
    return Row(
      children: [
        AppLocalImage(
          path: AppResource().mineVipLeft,
          width: 25.w,
        ),
        SizedBox(
          width: 5.5.w,
        ),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppGradientText(
              "SVIP会员",
              textAlign: TextAlign.left,
              gradient: AppTheme().vipGradient,
              style: AppTheme().textStyle(fontSize: 14.sp),
            ),
            AppGradientText(
              "未开通 | 专属特权，尊享体验",
              textAlign: TextAlign.left,
              gradient: AppTheme().vipGradient,
              style: AppTheme().textStyle(fontSize: 10.sp),
            )
          ],
        ))
      ],
    );
  }
}
