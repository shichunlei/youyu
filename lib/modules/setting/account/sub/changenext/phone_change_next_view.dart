import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/tag_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/setting/account/sub/changenext/model/phone_change_model.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/input/app_normal_input.dart';
import 'package:youyu/widgets/app/input/app_verify_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'phone_change_next_logic.dart';

class PhoneChangeNextPage extends StatelessWidget {
  PhoneChangeNextPage({Key? key}) : super(key: key);

  final logic = Get.find<PhoneChangeNextLogic>(tag: AppTapUtils.tag);

  @override
  Widget build(BuildContext context) {
    return AppPage<PhoneChangeNextLogic>(
      tag: AppTapUtils.tag,
      appBar: const AppTopBar(
        title: "绑定手机号修改",
      ),
      childBuilder: (s) {
        return Obx(() => AppColumn(
              margin: EdgeInsets.all(15.w),
              children: [
                AppColumn(
                  color: AppTheme.colorDarkBg,
                  radius: 6.w,
                  children: [
                    AppNormalInput(
                        textColor: AppTheme.colorTextWhite,
                        backgroundColor: Colors.transparent,
                        placeHolderColor: AppTheme.colorTextDark,
                        height: 60.h,
                        controller: logic.mobileController,
                        onChanged: (s) {},
                        placeHolder: logic.model.step == PhoneChangeStep.first
                            ? "原手机号"
                            : "新手机号"),
                    Container(
                      height: 1.h,
                      color: AppTheme.colorLine,
                      margin: EdgeInsets.symmetric(horizontal: 15.w),
                    ),
                    AppVerifyInput(
                        textColor: AppTheme.colorTextWhite,
                        key: logic.verifyKey,
                        verifyTextColor: AppTheme.colorTextDark,
                        backgroundColor: Colors.transparent,
                        height: 60.h,
                        controller: logic.verifyController,
                        placeHolderColor: AppTheme.colorTextDark,
                        onClickVerify: () {
                          logic.sendSms();
                        },
                        placeHolder: "请输入验证码"),
                  ],
                ),
                Opacity(
                  opacity: s.isVerify.value ? 1 : 0.5,
                  child: AppColorButton(
                    onClick: () {
                      s.requestCommit();
                    },
                    margin: EdgeInsets.only(top: 60.h),
                    height: 52.h,
                    titleColor: AppTheme.colorTextWhite,
                    title: logic.model.step == PhoneChangeStep.first
                        ? "下一步"
                        : "完成",
                    bgGradient: AppTheme().btnGradient,
                  ),
                )
              ],
            ));
      },
    );
  }
}
