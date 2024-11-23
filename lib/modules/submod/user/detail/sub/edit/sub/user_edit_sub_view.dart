import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/input/app_normal_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'user_edit_sub_logic.dart';

class UserEditSubPage extends StatelessWidget {
  UserEditSubPage({Key? key}) : super(key: key);

  final logic = Get.find<UserEditSubLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<UserEditSubLogic>(
      appBar: AppTopBar(
        title: logic.editType == UserEditType.nickName ? "昵称" : "个性签名",
      ),
      childBuilder: (s) {
        return Obx(() => AppColumn(
              margin: EdgeInsets.all(15.w),
              children: [
                AppNormalInput(
                    textColor: AppTheme.colorTextWhite,
                    backgroundColor: AppTheme.colorDarkBg,
                    placeHolderColor: AppTheme.colorTextDark,
                    height: 44.h,
                    controller: logic.controller,
                    onChanged: (s) {},
                    placeHolder: logic.editType == UserEditType.nickName
                        ? "请输入昵称..."
                        : "请输入个性签名"),
                Opacity(
                  opacity: s.isVerify.value ? 1 : 0.5,
                  child: AppColorButton(
                    onClick: () {
                      s.requestCommit();
                    },
                    margin: EdgeInsets.only(top: 60.h),
                    height: 52.h,
                    titleColor: AppTheme.colorTextWhite,
                    title: "保存",
                    bgGradient: AppTheme().btnGradient,
                  ),
                )
              ],
            ));
      },
    );
  }
}
