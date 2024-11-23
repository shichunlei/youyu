import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/app_controller.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'setting_check_update_logic.dart';

class SettingCheckUpdatePage extends StatelessWidget {
  SettingCheckUpdatePage({Key? key}) : super(key: key);

  final logic = Get.find<SettingCheckUpdateLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<SettingCheckUpdateLogic>(
      appBar: const AppTopBar(
        title: "检查更新",
      ),
      childBuilder: (s) {
        return AppColumn(
          mainAxisSize: MainAxisSize.min,
          margin: EdgeInsets.all(15.w),
          children: [
            AppColumn(
              width: double.infinity,
              height: 140.h,
              color: AppTheme.colorDarkBg,
              radius: 7.w,
              padding: EdgeInsets.all(25.h),
              children: [
                const Expanded(child: SizedBox.shrink()),
                Text(
                  '版本号：V${AppController.to.version}',
                  style: AppTheme().textStyle(
                      fontSize: 14.sp, color: AppTheme.colorTextSecond),
                )
              ],
            ),
            AppColorButton(
              margin: EdgeInsets.only(top: 27.h),
              titleColor: AppTheme.colorTextWhite,
              title: "立即更新",
              fontSize: 18.sp,
              bgGradient: AppTheme().btnGradient,
              height: 50.h,
              onClick: () {
                logic.onCheckVersion();
              },
            ),
          ],
        );
      },
    );
  }
}
