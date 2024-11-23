import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/input/app_normal_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'real_auth_index_logic.dart';

class RealAuthIndexPage extends StatelessWidget {
  RealAuthIndexPage({Key? key}) : super(key: key);

  final logic = Get.find<RealAuthIndexLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<RealAuthIndexLogic>(
      appBar: const AppTopBar(
        title: "实名认证",
      ),
      childBuilder: (s) {
        return Container(
          padding: EdgeInsets.only(left: 15.h, right: 15.h, bottom: 15.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppColumn(
                  margin: EdgeInsets.only(top: 15.h),
                  width: double.infinity,
                  color: AppTheme.colorDarkBg,
                  radius: 6.w,
                  padding: EdgeInsets.only(left: 15.w, right: 15.w),
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 17.h,
                    ),
                    AppNormalInput(
                      backgroundColor: AppTheme.colorDarkLightBg,
                      height: 50.h,
                      textColor: AppTheme.colorTextWhite,
                      placeHolder: "请输入真实姓名",
                      controller: logic.nameController,
                      focusNode: logic.nameFocusNode,
                    ),
                    SizedBox(
                      height: 17.h,
                    ),
                    AppNormalInput(
                      height: 50.h,
                      backgroundColor: AppTheme.colorDarkLightBg,
                      placeHolder: "请输入身份证号",
                      textColor: AppTheme.colorTextWhite,
                      controller: logic.numberController,
                      focusNode: logic.numberFocusNode,
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    Text(
                      "认证须知",
                      style: AppTheme().textStyle(
                          fontSize: 16.sp,
                          color: AppTheme.colorTextPrimary),
                    ),
                    Text(
                      "1.该认证仅支持中国内地 (不含港澳台地区) 的用户。"
                      "\n2.请确保填写身份证信息真实并与本人一致。"
                      "\n3.您所提供的身份信息仅用于身份验证，未经您本人的许可不会被用于其他用途。 "
                      "\n4.为保护用户权益，开启实名认证后我们将不提供解除恢复的功能，请谅解。 "
                      "\n5.一个身份证可用于多个用户账号实名认证。",
                      maxLines: 1000,
                      style: AppTheme().textStyle(
                          fontSize: 14.sp,
                          color: AppTheme.colorTextDark),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                  ],
                ),
                Obx(
                  () => Opacity(
                    opacity: logic.isVerify.value ? 1 : 0.5,
                    child: AppColorButton(
                      margin: EdgeInsets.only(top: 36.h),
                      titleColor: AppTheme.colorTextWhite,
                      title: "完成",
                      bgGradient: AppTheme().btnGradient,
                      height: 52.h,
                      onClick: () {
                        if (logic.isVerify()) {
                          logic.gotoFinish();
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
