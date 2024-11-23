import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/input/app_normal_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'message_remark_logic.dart';

//TODO:后面在做
class MessageRemarkPage extends StatelessWidget {
  MessageRemarkPage({Key? key}) : super(key: key);

  final logic = Get.find<MessageRemarkLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<MessageRemarkLogic>(
      appBar: const AppTopBar(
        title: "备注",
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

                    controller: logic.remarkController,
                    onChanged: (s) {},
                    placeHolder: "请输入备注..."),
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
