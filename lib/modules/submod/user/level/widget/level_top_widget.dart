import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/user/sub/user_level_control.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:flutter/material.dart';

class LevelTopWidget extends StatelessWidget {
  const LevelTopWidget(
      {super.key, required this.height, required this.curLevelModel});

  final UserCurLevelModel curLevelModel;
  final double height;

  @override
  Widget build(BuildContext context) {
    return AppRow(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      crossAxisAlignment: CrossAxisAlignment.center,
      height: height,
      children: [
        AppCircleNetImage(
          imageUrl: UserController.to.avatar,
          size: 66.h,
          borderWidth: 1.w,
          borderColor: AppTheme.colorMain,
        ),
        Expanded(
            child: AppColumn(
          mainAxisAlignment: MainAxisAlignment.center,
          margin: EdgeInsets.only(left: 20.w),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    UserController.to.nickname,
                    style: AppTheme().textStyle(
                        fontSize: 18.sp, color: const Color(0xFF000000)),
                  ),
                ),
                Text(
                  "升级所需经验值：${curLevelModel.limitExp}",
                  style: AppTheme().textStyle(
                      fontSize: 12.sp, color: AppTheme.colorTextPrimary),
                )
              ],
            ),
            SizedBox(
              height: 8.h,
            ),
            _progress(),
            SizedBox(
              height: 6.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "L${curLevelModel.curLevel}",
                  style: AppTheme().textStyle(
                      fontSize: 12.sp, color: AppTheme.colorTextPrimary),
                ),
                Text(
                  curLevelModel.nextLevel == -1
                      ? "MAX"
                      : "L${curLevelModel.nextLevel}",
                  style: AppTheme().textStyle(
                      fontSize: 12.sp, color: AppTheme.colorTextPrimary),
                )
              ],
            )
          ],
        ))
      ],
    );
  }

  _progress() {
    return SizedBox(
      height: 8.h,
      child: ClipRRect(
        // 边界半径（`borderRadius`）属性，圆角的边界半径。
        borderRadius: BorderRadius.all(Radius.circular(10.h)),
        child: LinearProgressIndicator(
          value: ((curLevelModel.limitExp ?? 0) + curLevelModel.exp) > 0
              ? curLevelModel.exp / ((curLevelModel.limitExp ?? 0) + curLevelModel.exp)
              : 0,
          backgroundColor: const Color(0xFF399560),
          valueColor: const AlwaysStoppedAnimation<Color>(
            Color(0xFFBFFF00),
          ),
        ),
      ),
    );
  }
}
