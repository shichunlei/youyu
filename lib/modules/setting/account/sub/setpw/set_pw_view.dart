import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/input/app_normal_input.dart';
import 'package:youyu/widgets/app/input/app_verify_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'set_pw_logic.dart';

///设置密码 或者 修改密码
class SetPwPage extends StatelessWidget {
  SetPwPage({Key? key}) : super(key: key);

  final logic = Get.find<SetPwLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<SetPwLogic>(
      appBar: AppTopBar(
        title: logic.pwType == SetPwType.set ? "设置密码" : "修改登录密码",
      ),
      childBuilder: (s) {
        return Obx(() => AppColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              margin: EdgeInsets.all(15.w),
              children: [
                AppColumn(
                  color: AppTheme.colorDarkBg,
                  padding: EdgeInsets.only(bottom: 17.h),
                  radius: 6.w,
                  children: [
                    if (logic.pwType == SetPwType.change) _verifyWidget(),
                    _firstWidget(),
                    _twiceWidget()
                  ],
                ),
                AppColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  padding: EdgeInsets.symmetric(vertical: 20.w,horizontal: 10.w),
                  children: [
                    Text('1.密码由6-16个字符内的数字和英文组成',style: AppTheme().textStyle(fontSize: 12.sp,color: AppTheme.colorTextDark),),
                    SizedBox(height: 4.h,),
                    Text('2.数字部分不能是2位以上连续或重复的数字',style: AppTheme().textStyle(fontSize: 12.sp,color: AppTheme.colorTextDark),)
                  ],
                ),
                Opacity(
                  opacity: s.isVerify.value ? 1 : 0.5,
                  child: AppColorButton(
                    onClick: () {
                      s.requestCommit();
                    },
                    margin: EdgeInsets.only(top: 35.h),
                    height: 52.h,
                    titleColor: AppTheme.colorTextWhite,
                    title: "完成",
                    bgGradient: AppTheme().btnGradient,
                  ),
                )
              ],
            ));
      },
    );
  }

  _verifyWidget() {
    return Column(
      children: [
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
        Container(
          height: 1.h,
          color: AppTheme.colorLine,
          margin: EdgeInsets.symmetric(horizontal: 15.w),
        ),
      ],
    );
  }

  _firstWidget() {
    return Column(
      children: [
        AppNormalInput(
            isShowEye: true,
            textColor: AppTheme.colorTextWhite,
            backgroundColor: Colors.transparent,
            placeHolderColor: AppTheme.colorTextDark,
            height: 60.h,
            eyeColor: AppTheme.colorTextWhite,
            controller: logic.pwController,
            onChanged: (s) {},
            placeHolder: logic.pwType == SetPwType.set ? "请输入密码" : "请输入新密码"),
        Container(
          height: 1.h,
          color: AppTheme.colorLine,
          margin: EdgeInsets.symmetric(horizontal: 15.w),
        ),
      ],
    );
  }

  _twiceWidget() {
    return Column(
      children: [
        AppNormalInput(
            isShowEye: true,
            textColor: AppTheme.colorTextWhite,
            backgroundColor: Colors.transparent,
            placeHolderColor: AppTheme.colorTextDark,
            height: 60.h,
            eyeColor: AppTheme.colorTextWhite,
            controller: logic.twicePwController,
            onChanged: (s) {},
            placeHolder: "再次输入密码"),
        Container(
          height: 1.h,
          color: AppTheme.colorLine,
          margin: EdgeInsets.symmetric(horizontal: 15.w),
        ),
      ],
    );
  }
}
