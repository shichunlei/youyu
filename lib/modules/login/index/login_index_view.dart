import 'package:flutter/services.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/app_controller.dart';
import 'package:youyu/modules/submod/web/param/web_model.dart';
import 'package:youyu/router/router.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/widgets/top_bg/top_ba.dart';
import 'login_index_logic.dart';

class LoginIndexPage extends StatelessWidget {
  LoginIndexPage({Key? key}) : super(key: key);

  final logic = Get.find<LoginIndexLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<LoginIndexLogic>(
      uiOverlayStyle: SystemUiOverlayStyle.dark,
      topBg: const TopBgLogin(),
      resizeToAvoidBottomInset: false,
      appBar: const AppTopBar(
        backgroundColor: Colors.transparent,
        title: "",
        height: 0,
        hideBackArrow: true,
      ),
      backgroundColor: AppTheme.colorWhiteBg,
      childBuilder: (s) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            AppColumn(
              width: double.infinity,
              margin:
                  EdgeInsets.only(bottom: ScreenUtils.safeBottomHeight + 20.h),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 186.h,
                    ),
                    AppLocalImage(
                      path: AppResource().bigLogo,
                      width: 103.w,
                    ),
                    SizedBox(
                      height: 80.h,
                    ),
                    _centerWidget(),
                  ],
                ),
                _bottomWidget(),
              ],
            ),
          ],
        );
      },
    );
  }

  ///核心区域
  _centerWidget() {
    return AppColumn(
      margin: EdgeInsets.only(left: 50.w, right: 50.w),
      children: [
        //一键登录
        AppColorButton(
          titleColor: AppTheme.colorTextWhite,
          title: "本机号码一键登录",
          bgGradient: AppTheme().btnGradient,
          height: 50.h,
          onClick: () {
            if (logic.isAgree.value) {
              logic.onClickOneKey();
            } else {
              ToastUtils.show("请先勾选同意隐私政策与用户协议");
            }
          },
        ),
        //其他登录
        AppColorButton(
          margin: EdgeInsets.only(top: 26.h),
          titleColor: AppTheme.colorTextDark,
          title: "其他账号登录",
          borderColor: AppTheme.colorTextDark,
          height: 50.h,
          onClick: () {
            Get.toNamed(AppRouter().loginPages.loginAccountRoute.name);
          },
        ),
        SizedBox(
          height: 33.h,
        ),
        Offstage(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //TODO:微信登录
              AppLocalImage(
                onTap: () {
                  if (logic.isAgree.value) {
                  } else {
                    ToastUtils.show("请先勾选同意隐私政策与用户协议");
                  }
                },
                path: AppResource().wx,
                width: 52.w,
              ),
              SizedBox(
                width: 70.w,
              ),
              //TODO:qq登录
              AppLocalImage(
                onTap: () {
                  if (logic.isAgree.value) {
                  } else {
                    ToastUtils.show("请先勾选同意隐私政策与用户协议");
                  }
                },
                path: AppResource().qq,
                width: 52.w,
              )
            ],
          ),
        ),
        SizedBox(
          height: 40.h,
        ),
        InkWell(
          onTap: () {
            //登录反馈
            Get.toNamed(AppRouter().loginPages.loginFeedBackRoute.name);
          },
          child: SizedBox(
            height: 30.h,
            child: Center(
              child: Text(
                "无法登录？",
                style: AppTheme().textStyle(),
              ),
            ),
          ),
        )
      ],
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
