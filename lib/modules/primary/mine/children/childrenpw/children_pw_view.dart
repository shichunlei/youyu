import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/tag_utils.dart';

import 'package:youyu/widgets/code/code_input.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'children_pw_logic.dart';

class ChildrenPwPage extends StatelessWidget {
  ChildrenPwPage({Key? key}) : super(key: key);

  final logic = Get.find<ChildrenPwLogic>(tag: AppTapUtils.tag);

  @override
  Widget build(BuildContext context) {
    return AppPage<ChildrenPwLogic>(
      tag: AppTapUtils.tag,
      appBar: const AppTopBar(
        title: "青少年模式",
      ),
      childBuilder: (s) {
        return Obx(() => AppColumn(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              children: [
                AppColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  radius: 6.w,
                  padding: EdgeInsets.only(
                      left: 14.w, right: 14.w, top: 18.h, bottom: s.isShowFind? 15.h: 30.h),
                  color: AppTheme.colorDarkBg,
                  children: [
                    // 标题
                    Text("${s.title}",
                        maxLines: 10,
                        style: AppTheme().textStyle(
                            fontSize: 18.sp,
                            color: AppTheme.colorTextSecond)),
                    // 副标题
                    if (s.subTitle?.isNotEmpty == true)
                      SizedBox(
                        height: 15.h,
                      ),
                    if (s.subTitle?.isNotEmpty == true)
                      Text(s.subTitle ?? "",
                          maxLines: 10,
                          style: AppTheme().textStyle(
                              fontSize: 14.sp,
                              color: AppTheme.colorTextDark)),
                    SizedBox(
                      height: 15.h,
                    ),

                    /// 输入框
                    Container(
                      margin: EdgeInsets.only(right: 80.w),
                      child: CodeInputContainer(
                          itemColor: AppTheme.colorDarkLightBg,
                          childAspectRatio: 1,
                          crossAxisSpacing: 16.w,
                          count: 4,
                          onResult: (code) {
                            s.password.value = code;
                          }),
                    ),
                    // 显示找回
                    if (s.isShowFind)
                      SizedBox(
                        height: 15.h,
                      ),
                    if (s.isShowFind)
                      AppContainer(
                        height: 30.h,
                        child: Text(
                          '忘记了？找回密码',
                          style: AppTheme().textStyle(
                              fontSize: 12.sp,
                              color: AppTheme.colorMain),
                        ),
                      )
                  ],
                ),
                // button
                Opacity(
                  opacity: s.password.value.length == 4 ? 1 : 0.5,
                  child: AppColorButton(
                    onClick: () {
                      s.onCommit();
                    },
                    margin: EdgeInsets.only(top: 60.h),
                    height: 52.h,
                    titleColor: AppTheme.colorTextWhite,
                    title: s.btnTitle ?? "",
                    bgGradient: AppTheme().btnGradient,
                  ),
                )
              ],
            ));
      },
    );
  }
}
