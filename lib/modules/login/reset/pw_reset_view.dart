import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/app_controller.dart';
import 'package:youyu/modules/submod/web/param/web_model.dart';
import 'package:youyu/router/router.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/input/app_normal_input.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/input/app_verify_input.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'pw_reset_logic.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class PwResetPage extends StatelessWidget {
  PwResetPage({Key? key}) : super(key: key);

  final logic = Get.find<PwResetLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<PwResetLogic>(
      appBar: const AppTopBar(
        backgroundColor: AppTheme.colorDarkBg,
        title: "重置密码",
      ),
      backgroundColor: AppTheme.colorDarkBg,
      resizeToAvoidBottomInset: false,
      childBuilder: (s) {
        return KeyboardActions(
            config: AppTheme().keyboardActions([
              AppTheme().keyboardActionItem(logic.mobileFocusNode),
              AppTheme().keyboardActionItem(logic.verifyFocusNode),
              AppTheme().keyboardActionItem(logic.pwFocusNode)
            ]),
            child: AppColumn(
              width: double.infinity,
              margin:
                  EdgeInsets.only(bottom: ScreenUtils.safeBottomHeight + 20.h),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 50.h,
                    ),
                    AppLocalImage(
                      path: AppResource().bigLogo,
                      width: 75.w,
                    ),
                    SizedBox(
                      height: 52.h,
                    ),
                    _centerWidget()
                  ],
                ),
                _bottomWidget(),
              ],
            ));
      },
    );
  }

  //核心区域
  _centerWidget() {
    return Container(
      margin: EdgeInsets.only(left: 38.w, right: 38.w),
      child: Column(
        children: [
          AppNormalInput(
              backgroundColor: AppTheme.colorTextWhite,
              height: 50.h,
              controller: logic.mobileController,
              focusNode: logic.mobileFocusNode,
              onChanged: (s) {},
              placeHolder: "请输入手机号"),
          SizedBox(
            height: 20.h,
          ),
          AppVerifyInput(
              key: logic.loginVerifyKey,
              backgroundColor: AppTheme.colorTextWhite,
              height: 50.h,
              controller: logic.verifyController,
              focusNode: logic.verifyFocusNode,
              onClickVerify: () {
                logic.sendSms();
              },
              placeHolder: "请输入验证码"),
          SizedBox(
            height: 20.h,
          ),
          AppNormalInput(
              backgroundColor: AppTheme.colorTextWhite,
              height: 50.h,
              controller: logic.pwdController,
              focusNode: logic.pwFocusNode,
              isShowEye: true,
              onChanged: (s) {},
              placeHolder: "请输入密码"),
          SizedBox(
            height: 18.h,
          ),
          Text(
            '密码必须是6~16字符内数字英文组合哦！',
            style: AppTheme().textStyle(
                fontSize: 14.sp, color: const Color(0xFF9CA3AF)),
          ),
          SizedBox(
            height: 46.h,
          ),
          //立即重置
          AppColorButton(
            titleColor: AppTheme.colorTextWhite,
            title: "立即重置",
            bgGradient: AppTheme().btnGradient,
            height: 50.h,
            onClick: () {
              logic.requestCommit();
            },
          ),
        ],
      ),
    );
  }

  ///底部
  _bottomWidget() {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppLocalImage(
              onTap: () {
                logic.isAgree.value = !logic.isAgree.value;
              },
              path: logic.isAgree.value
                  ? AppResource().check
                  : AppResource().unCheck,
              width: 16.w,
            ),
            SizedBox(
              width: 4.w,
            ),
            RichText(
                text: TextSpan(
              text: "",
              style: AppTheme().textStyle(
                  color: AppTheme.colorTextPrimary, fontSize: 13),
              children: <TextSpan>[
                TextSpan(
                  style: AppTheme().textStyle(
                      color: AppTheme.colorTextPrimary, fontSize: 13),
                  text: "我已阅读并同意",
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      logic.isAgree.value = !logic.isAgree.value;
                    },
                ),
                TextSpan(
                  style: AppTheme().textStyle(
                      color: AppTheme.colorMain, fontSize: 13),
                  text: "《隐私政策》",
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Get.toNamed(AppRouter().otherPages.webRoute.name,
                          arguments: WebParam(
                              url: AppController.to.privacyAgreement,
                              title: "隐私政策"));
                    },
                ),
                TextSpan(
                    style: AppTheme().textStyle(
                        color: AppTheme.colorTextPrimary, fontSize: 13),
                    text: " 和 "),
                TextSpan(
                  style: AppTheme().textStyle(
                      color: AppTheme.colorMain, fontSize: 13),
                  text: "《用户协议》",
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Get.toNamed(AppRouter().otherPages.webRoute.name,
                          arguments: WebParam(
                              url: AppController.to.userAgreement,
                              title: "用户协议"));
                    },
                ),
              ],
            ))
          ],
        ));
  }
}
