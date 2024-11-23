import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/selected/selected_widget.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:youyu/widgets/app/input/app_normal_input.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import 'login_info_logic.dart';

class LoginInfoPage extends StatelessWidget {
  LoginInfoPage({Key? key}) : super(key: key);

  final logic = Get.find<LoginInfoLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<LoginInfoLogic>(
      appBar: const AppTopBar(
        backgroundColor: AppTheme.colorDarkBg,
        title: "",
      ),
      backgroundColor: AppTheme.colorDarkBg,
      resizeToAvoidBottomInset: false,
      childBuilder: (s) {
        return KeyboardActions(
            config: AppTheme().keyboardActions([
              AppTheme().keyboardActionItem(logic.nameFocusNode),
            ]),
            child: AppColumn(
              width: double.infinity,
              margin:
                  EdgeInsets.only(bottom: ScreenUtils.safeBottomHeight + 10.h),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 40.h,
                    ),
                    InkWell(
                      onTap: () {
                        logic.selectHead();
                      },
                      child: Stack(
                        children: [
                          Obx(
                            () => SizedBox(
                              width: 90.w,
                              height: 90.w,
                              child: AppNetImage(
                                imageUrl: logic.avatar.value,
                                width: 90.w,
                                height: 90.w,
                                fit: BoxFit.cover,
                                radius: BorderRadius.circular(90.w),
                                defaultWidget: _defaultHead(),
                                errorWidget: _defaultHead(),
                              ),
                            ),
                          ),
                          Positioned(
                              right: 0,
                              bottom: 0,
                              child: AppLocalImage(
                                path: AppResource().smallPhoto,
                                width: 22.w,
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 52.h,
                    ),
                    _centerWidget()
                  ],
                ),
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
            backgroundColor: AppTheme.colorTextWhite,
            height: 50.h,
            controller: logic.nameController,
            focusNode: logic.nameFocusNode,
            onChanged: (s) {},
            placeHolder: "请输入昵称"),
        SizedBox(
          height: 20.h,
        ),
        SelectedWidget(
          backgroundColor: AppTheme.colorTextWhite,
          height: 50.h,
          controller: logic.sexController,
          placeHolder: "请选择性别（选择后不可更改）",
          onClick: () {
            logic.selectSex();
          },
        ),
        SizedBox(
          height: 20.h,
        ),
        SelectedWidget(
          backgroundColor: AppTheme.colorTextWhite,
          height: 50.h,
          controller: logic.birthDayController,
          placeHolder: "请选择生日",
          onClick: () {
            logic.selectBirthDay();
          },
        ),
        SizedBox(
          height: 18.h,
        ),
        Text(
          '未满18岁不可以注册哦',
          style: AppTheme().textStyle(
              fontSize: 14.sp, color: const Color(0xFF9CA3AF)),
        ),
        SizedBox(
          height: 51.h,
        ),
        //登录
        AppColorButton(
          titleColor: AppTheme.colorTextWhite,
          title: "立即注册",
          bgGradient: AppTheme().btnGradient,
          height: 50.h,
          onClick: () {
            logic.requestCommit();
          },
        ),
      ],
    );
  }

  //默认头像
  _defaultHead() {
    return AppLocalImage(
      path: AppResource().defaultHead,
      fit: BoxFit.cover,
      width: 90.w,
      radius: BorderRadius.circular(90.w),
    );
  }
}
