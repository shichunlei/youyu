import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';

class WheelGameRuleDialog extends StatelessWidget {
  const WheelGameRuleDialog({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    double imageH =
        (ScreenUtils.screenWidth - 18 * 2.w).imgHeight(Size(339, 364));
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Get.back();
        },
        child: Center(
          child: AppStack(
            height: imageH,
            alignment: Alignment.center,
            children: [
              AppLocalImage(
                path: AppResource().gameWheelRuleBg,
                width: ScreenUtils.screenWidth - 18 * 2.w,
              ),
              Positioned(
                  left: 0,
                  right: 0,
                  top: 75.h,
                  bottom: 20.h,
                  child: ListView(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 25.w),
                        child: Text(
                          text,
                          style: AppTheme()
                              .textStyle(fontSize: 13.sp, color: Colors.white),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
