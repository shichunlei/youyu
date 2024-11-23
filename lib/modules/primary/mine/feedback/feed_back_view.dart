import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/input/app_area_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'feed_back_logic.dart';

class FeedBackPage extends StatelessWidget {
  FeedBackPage({Key? key}) : super(key: key);

  final logic = Get.find<FeedBackLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<FeedBackLogic>(
      appBar: const AppTopBar(
        title: "意见反馈",
      ),
      childBuilder: (s) {
        return AppColumn(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          padding: EdgeInsets.all(15.w),
          children: [
            Column(
              children: [
                AppAreaInput(
                  textColor: AppTheme.colorTextWhite,
                  controller: s.contentController,
                  bgColor: AppTheme.colorDarkBg,
                  placeHolderColor: AppTheme.colorTextDark,
                  fontSize: 14.sp,
                  height: 140.h,
                  placeHolder: "请详细描述你想反馈的内容，这会有利于平台更快、更准确的处理反馈",
                  theme: AppWidgetTheme.dark,
                ),
                SizedBox(
                  height: 17.h,
                ),
                AppAreaInput(
                  textColor: AppTheme.colorTextWhite,
                  controller: s.contactController,
                  bgColor: AppTheme.colorDarkBg,
                  placeHolderColor: AppTheme.colorTextDark,
                  fontSize: 14.sp,
                  height: 140.h,
                  placeHolder: "请留下你的联系方式",
                  theme: AppWidgetTheme.dark,
                ),
              ],
            ),
            Obx(() => Opacity(
                  opacity: s.isVerify.value ? 1 : 0.5,
                  child: AppColorButton(
                    onClick: () {
                      s.onCommit();
                    },
                    margin: EdgeInsets.only(bottom: ScreenUtils.safeBottomHeight + 10.h),
                    height: 52.h,
                    titleColor: AppTheme.colorTextWhite,
                    title: "提交",
                    bgGradient: AppTheme().btnGradient,
                  ),
                )),
          ],
        );
      },
    );
  }
}
