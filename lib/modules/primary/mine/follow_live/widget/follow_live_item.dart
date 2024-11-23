import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/widgets/image/stack_lock_image.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/room_list_item.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:flutter/material.dart';

class FollowLiveItem extends StatelessWidget {
  const FollowLiveItem({super.key, required this.model, required this.onClickCancelFocus, required this.onClickLive});

  final RoomListItem model;
  final Function onClickCancelFocus;
  final Function onClickLive;
  @override
  Widget build(BuildContext context) {
    return AppColumn(
      onTap: () {
        onClickLive();
      },
      height: 68.h,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      children: [
        Expanded(
            child: AppRow(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StackLockImage(
              imageUrl: model.headAvatar ?? "",
              isLock: model.lock == 1,
              width: 50.w,
              height: 50.w,
              lockWidth: 24.w * 1.2,
              lockHeight: 32.w * 1.2,
              borderRadius: BorderRadius.circular(10.w),
            ),
            Expanded(
                child: AppColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              margin: EdgeInsets.symmetric(horizontal: 6.w),
              children: [
                Text(
                  model.name,
                  style: AppTheme().textStyle(
                      fontSize: 16.sp, color: AppTheme.colorTextWhite),
                ),
                Text(
                  "ID:${model.fancyNumber}",
                  style: AppTheme().textStyle(
                      fontSize: 12.sp, color: AppTheme.colorTextSecond),
                )
              ],
            )),
            AppColorButton(
              onClick: () {
                onClickCancelFocus();
              },
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              height: 20.h,
              fontSize: 10.sp,
              title: "取消关注",
              titleColor: AppTheme.colorTextWhite,
              bgColor: const Color(0xFFCDCDCD),
            )
          ],
        )),
        Container(
          height: 0.5,
          color: AppTheme.colorLine,
        )
      ],
    );
  }
}
