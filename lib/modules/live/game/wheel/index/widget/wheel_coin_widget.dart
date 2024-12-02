import 'package:flutter/material.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';

class WheelCoinWidget extends StatelessWidget {
  const WheelCoinWidget({super.key, required this.onTap});

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppStack(
      onTap: onTap,
      alignment: Alignment.centerLeft,
      height: 86 / 2.h,
      children: [
        AppLocalImage(
          path: AppResource().gameWheelCoinBg,
          width: 175 / 2.w,
          height: 86 / 2.h,
        ),
        AppRow(
          margin: EdgeInsets.only(left: 38.w),
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              UserController.to.coins.toString(),
              style: AppTheme()
                  .textStyle(fontSize: 9.sp, color: const Color(0xFFFFF9C5)),
            ),
            SizedBox(width: 12.w,),
            AppLocalImage(
              path: AppResource().gameWheelRight,
              width: 3.w,
              height: 6.w,
            )
          ],
        )
      ],
    );
  }
}
