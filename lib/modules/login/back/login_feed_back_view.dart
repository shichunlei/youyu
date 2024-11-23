import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/input/app_area_input.dart';
import 'package:youyu/widgets/app/input/app_normal_input.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';


import 'login_feed_back_logic.dart';

class LoginFeedBackPage extends StatelessWidget {
  LoginFeedBackPage({Key? key}) : super(key: key);

  final logic = Get.find<LoginFeedBackLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<LoginFeedBackLogic>(
        appBar: const AppTopBar(
          backgroundColor: AppTheme.colorDarkBg,
          title: "登录反馈",
        ),
        backgroundColor: AppTheme.colorDarkBg,
        childBuilder: (s) {
          return KeyboardActions(
              config: AppTheme().keyboardActions([
                AppTheme().keyboardActionItem(logic.qaContentFocusNode),
                AppTheme().keyboardActionItem(logic.loginTypeFocusNode),
                AppTheme().keyboardActionItem(logic.accountFocusNode),
                AppTheme().keyboardActionItem(logic.mobileFocusNode)
              ]),
              child: SingleChildScrollView(child: _contentWidget()));
        });
  }

  _contentWidget() {
    return AppColumn(
      margin: EdgeInsets.only(
          left: 15.w,
          right: 15.w,
          top: 17.h,
          bottom: ScreenUtils.safeBottomHeight + 10.h),
      children: [
        _item(
            controller: logic.qaContentController,
            isRequire: true,
            title: "您在登录时遇到了什么问题？",
            placeHolder: "请输入问题",
            focusNode: logic.qaContentFocusNode,
            onChanged: (s) {
              logic.updateCommitState();
            },
            isArea: true),
        InkWell(
          onTap: () {
            logic.onSelectLoginType();
          },
          child: _item(
              controller: logic.loginTypeController,
              isRequire: false,
              focusNode: logic.loginTypeFocusNode,
              title: "您的登录方式是？",
              isEnable: false,
              placeHolder: "手机/微信/QQ/苹果ID",
              onChanged: (s) {
                logic.updateCommitState();
              },
              isArea: false),
        ),
        _item(
            controller: logic.accountController,
            isRequire: false,
            title: "您的账号是？",
            focusNode: logic.accountFocusNode,
            placeHolder: "请输入您的登录账号",
            onChanged: (s) {
              logic.updateCommitState();
            },
            isArea: false),
        _item(
            controller: logic.mobileController,
            isRequire: true,
            title: "您的手机号是？",
            focusNode: logic.mobileFocusNode,
            placeHolder: "请输入您的手机号",
            onChanged: (s) {
              logic.updateCommitState();
            },
            isArea: false),
        SizedBox(
          height: 100.h,
        ),
        Obx(() => Opacity(
              opacity: logic.isCanCommit.value ? 1 : 0.5,
              child: AppColorButton(
                titleColor: AppTheme.colorTextWhite,
                title: "确定",
                bgGradient: AppTheme().btnGradient,
                height: 50.h,
                onClick: () {
                  logic.requestCommit();
                },
              ),
            ))
      ],
    );
  }

  _item(
      {required bool isRequire,
      required String title,
      bool isEnable = true,
      required String placeHolder,
      required ValueChanged<String> onChanged,
      required TextEditingController controller,
      required FocusNode focusNode,
      required bool isArea}) {
    return AppColumn(
      margin: EdgeInsets.only(top: 20.h),
      padding: EdgeInsets.only(left: 15.w, right: 15.w),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
            text: TextSpan(
          children: <TextSpan>[
            if (isRequire)
              TextSpan(
                  style: AppTheme().textStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppTheme.colorRed),
                  text: "* "),
            TextSpan(
              style: AppTheme().textStyle(
                  color: AppTheme.colorTextWhite, fontSize: 14),
              text: title,
            ),
          ],
        )),
        SizedBox(
          height: 8.h,
        ),
        if (isArea)
          AppAreaInput(
              controller: controller,
              theme: AppWidgetTheme.light,
              maxLength: 200,
              height: 145.h,
              focusNode: focusNode,
              onChanged: onChanged,
              placeHolder: placeHolder)
        else
          AppNormalInput(
              enabled: isEnable,
              controller: controller,
              backgroundColor: AppTheme.colorTextWhite,
              height: 52.h,
              focusNode: focusNode,
              onChanged: onChanged,
              placeHolder: placeHolder)
      ],
    );
  }
}
