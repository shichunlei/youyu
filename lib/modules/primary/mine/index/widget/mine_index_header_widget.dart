import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/widgets/user/user_info_widget.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/widgets/app/icon/app_more_icon.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

///头像昵称等
class MineIndexHeaderWidget extends StatelessWidget {
  const MineIndexHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 26.w, right: 14.w, top: 15.h, bottom: 15.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(
            () => AppCircleNetImage(
              imageUrl: UserController.to.avatar,
              size: 68.w,
            ),
          ),
          SizedBox(
            width: 12.w,
          ),
          Obx(
            () => Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///名称等
                  UserInfoWidget(
                    isHighFancyNum: UserController.to.isHighFancyNum,
                    name: UserController.to.nickname,
                    nameFontSize: 20.sp,
                    sex: UserController.to.gender,
                  ),
                  SizedBox(height: 11.w),

                  ///id
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                          ClipboardData(text: '${UserController.to.fancyNumber}'));
                      ToastUtils.show('复制成功');
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'ID:${UserController.to.fancyNumber}',
                          style: AppTheme().textStyle(
                              fontSize: 14.sp,
                              color: AppTheme.colorTextSecond),
                        ),
                        SizedBox(width: 8.w),
                        AppLocalImage(
                          path: AppResource().copy,
                          width: 10.w,
                          height: 10.w,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 12.w,
          ),
          AppMoreIcon(
            height: 13.h,
            isShowText: false,
          )
        ],
      ),
    );
  }
}
