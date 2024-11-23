import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'children_logic.dart';

class ChildrenPage extends StatelessWidget {
  ChildrenPage({Key? key}) : super(key: key);

  final logic = Get.find<ChildrenLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<ChildrenLogic>(
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
                      left: 14.w, right: 14.w, top: 18.h, bottom: 33.h),
                  color: AppTheme.colorDarkBg,
                  children: [
                    Text(
                        "${s.title} ${UserController.to.childrenControl.isOpenChildren.value ? "已开启" : "未开启"}",
                        maxLines: 10,
                        style: AppTheme().textStyle(
                            fontSize: 18.sp,
                            color: AppTheme.colorTextSecond)),
                    SizedBox(
                      height: 15.h,
                    ),
                    Text(s.text1,
                        maxLines: 10,
                        style: AppTheme().textStyle(
                            fontSize: 14.sp,
                            color: AppTheme.colorTextDark)),
                    SizedBox(
                      height: 15.h,
                    ),
                    Text(s.text2,
                        maxLines: 10,
                        style: AppTheme().textStyle(
                            fontSize: 14.sp,
                            color: AppTheme.colorTextDark)),
                    SizedBox(
                      height: 15.h,
                    ),
                    Text(s.text3,
                        maxLines: 10,
                        style: AppTheme().textStyle(
                            fontSize: 14.sp,
                            color: AppTheme.colorTextDark)),
                  ],
                ),
                AppColorButton(
                  onClick: () {
                    s.onOpenChildren();
                  },
                  margin: EdgeInsets.only(top: 60.h),
                  height: 52.h,
                  titleColor: AppTheme.colorTextWhite,
                  title: UserController.to.childrenControl.isOpenChildren.value
                      ? "修改密码"
                      : "开启青少年模式",
                  bgGradient: AppTheme().btnGradient,
                ),
                if (UserController.to.childrenControl.isOpenChildren.value)
                  AppColorButton(
                    onClick: () {
                      s.onCloseChildren();
                    },
                    title: "关闭青少年模式",
                    margin: EdgeInsets.only(top: 16.h),
                    height: 52.h,
                    borderColor: AppTheme.colorMain,
                    bgColor: Colors.transparent,
                  )
              ],
            ));
      },
    );
  }
}
