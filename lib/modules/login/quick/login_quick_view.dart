import 'package:flutter/services.dart';
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
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:youyu/widgets/top_bg/top_ba.dart';

import 'login_quick_logic.dart';

class LoginQuickPage extends StatelessWidget {
  LoginQuickPage({Key? key}) : super(key: key);

  final logic = Get.find<LoginQuickLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<LoginQuickLogic>(
      uiOverlayStyle: SystemUiOverlayStyle.dark,
      topBg: const TopBgLogin(),
      appBar: AppTopBar(
        backgroundColor: Colors.transparent,
        title: "验证码登录/注册",
        backImg: AppResource().blackBack,
        titleColor: AppTheme.colorTextPrimary,
      ),
      backgroundColor: AppTheme.colorWhiteBg,
      resizeToAvoidBottomInset: false,
      childBuilder: (s) {
        return KeyboardActions(
            config: AppTheme().keyboardActions([
              AppTheme().keyboardActionItem(logic.mobileFocusNode),
              AppTheme().keyboardActionItem(logic.verifyFocusNode),
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
                      width: 103.w,
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
    return AppColumn(
        margin: EdgeInsets.only(left: 38.w, right: 38.w),
        children: [
          AppNormalInput(
              backgroundColor: AppTheme.inputBg,
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
              backgroundColor: AppTheme.inputBg,
              height: 50.h,
              controller: logic.verifyController,
              focusNode: logic.verifyFocusNode,
              onClickVerify: () {
                logic.sendSms();
              },
              placeHolder: "请输入验证码"),
          SizedBox(
            height: 146.h,
          ),
          //立即登录
          AppColorButton(
            titleColor: AppTheme.colorTextWhite,
            title: "立即登录",
            bgGradient: AppTheme().btnGradient,
            height: 50.h,
            onClick: () {
              logic.requestCommit();
            },
          ),
        ]);
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
              style: AppTheme()
                  .textStyle(color: AppTheme.colorTextPrimary, fontSize: 13),
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
                  style: AppTheme()
                      .textStyle(color: AppTheme.colorPrivacy, fontSize: 13),
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
                  style: AppTheme()
                      .textStyle(color: AppTheme.colorPrivacy, fontSize: 13),
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
