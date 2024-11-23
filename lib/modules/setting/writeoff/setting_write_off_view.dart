import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/dialog/app_tip_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'setting_write_off_logic.dart';

class SettingWriteOffPage extends StatelessWidget {
  SettingWriteOffPage({Key? key}) : super(key: key);

  final logic = Get.find<SettingWriteOffLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<SettingWriteOffLogic>(
      appBar: const AppTopBar(
        title: "注销账号",
      ),
      childBuilder: (s) {
        return AppColumn(
          mainAxisSize: MainAxisSize.min,
          margin: EdgeInsets.all(15.w),
          children: [
            AppColumn(
              mainAxisSize: MainAxisSize.min,
              width: double.infinity,
              color: AppTheme.colorDarkBg,
              radius: 7.w,
              padding: EdgeInsets.all(12.h),
              children: [
                RichText(
                    text: TextSpan(
                  text: '关于注销帐号: ',
                  style: AppTheme().textStyle(
                      fontSize: 14.sp, color: AppTheme.colorTextPrimary),
                  children: <TextSpan>[
                    TextSpan(
                        style: AppTheme().textStyle(
                            color: AppTheme.colorTextDark, fontSize: 14),
                        text:
                            "申请注销帐号后，会永久清空帐号的信息、资产和权益，且无法恢复，请谨慎操作！（将会有7日冷静期，期间不在登陆账号自行注销）"),
                  ],
                )),
              ],
            ),
            AppColorButton(
              margin: EdgeInsets.only(top: 27.h),
              titleColor: AppTheme.colorTextWhite,
              title: "注销",
              fontSize: 18.sp,
              bgColor: AppTheme.colorRed,
              height: 50.h,
              onClick: () {
                AppTipDialog().showTipDialog("提示", AppWidgetTheme.dark,
                    msg: "确定注销账号吗？", onCommit: () {
                      logic.commit();
                    });
              },
            ),
          ],
        );
      },
    );
  }
}
