import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/modules/submod/user/detail/user_detail_logic.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDetailFooter extends StatelessWidget {
  const UserDetailFooter({super.key, required this.logic});

  final UserDetailLogic logic;

  @override
  Widget build(BuildContext context) {
    return Obx(() => AppRow(
          width: double.infinity,
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (logic.targetUserInfo.value != null)
              logic.isFocus.value == true
                  ? const SizedBox.shrink()
                  : Expanded(
                      child: AppRow(
                      onTap: () {
                        logic.onClickFocus();
                      },
                      height: 48.h,
                      mainAxisAlignment: MainAxisAlignment.center,
                      radius: 99.w,
                      gradient: AppTheme().btnGradient,
                      children: [
                        AppLocalImage(
                          path: AppResource().userFocus,
                          width: 14.w,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          "关注",
                          style: AppTheme().textStyle(
                              fontSize: 16.sp,
                              color: AppTheme.colorTextWhite),
                        ),
                      ],
                    )),
            logic.isFocus.value == true
                ? const SizedBox.shrink()
                : SizedBox(
                    width: 29.w,
                  ),
            if (logic.ref != UserDetailRef.live)
              Expanded(
                  child: AppRow(
                onTap: () {
                  logic.onClickChat();
                },
                mainAxisAlignment: MainAxisAlignment.center,
                radius: 99.w,
                height: 48.h,
                gradient: AppTheme().btnGradient,
                children: [
                  AppLocalImage(
                    path: AppResource().userChat,
                    width: 14.w,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    "聊天",
                    style: AppTheme().textStyle(
                        fontSize: 16.sp, color: AppTheme.colorTextWhite),
                  ),
                ],
              ))
          ],
        ));
  }
}
