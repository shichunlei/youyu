import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';

class LiveClearCharmUserItem extends StatelessWidget {
  final UserInfo user;
  final int index;
  final bool isSelected;
  final bool isSelAll;
  final Function() onTap;

  const LiveClearCharmUserItem({
    Key? key,
    required this.isSelected,
    required this.onTap,
    required this.index,
    required this.user,
    required this.isSelAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppColumn(
      width: 52.w,
      height: 74.w,
      onTap: onTap,
      children: [
        AppStack(
          children: [
            _micSeatStatesBg(),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          _bottomText(),
          style: AppTheme().textStyle(
              fontSize: 13.sp, color: AppTheme.colorTextSecond),
        ),
      ],
    );
  }

  _bottomText() {
    if (index == 9) {
      if (isSelAll) {
        return "取消全选";
      } else {
        return "全选";
      }
    } else {
      return '$index号麦';
    }
  }

  ///麦位背景
  //userinfo.id = -1 空白
  _micSeatStatesBg() {
    if (index == 9) {
      return AppLocalImage(
        path: AppResource().liveMLAll,
        width: 52.w,
        height: 52.w,
      );
    }
    return AppStack(
      width: 52.w,
      height: 52.w,
      strokeWidth: 2.w,
      radius: 99.w,
      strokeColor: isSelected ? AppTheme.colorMain : Colors.transparent,
      alignment: Alignment.center,
      children: [
        AppContainer(
          width: double.infinity,
          height: double.infinity,
          radius: 99.w,
          color: const Color(0xFFAFAFAF),
        ),
        AppLocalImage(
          path: (index == 8)
              ? AppResource().liveSeatSofa
              : AppResource().liveSeatNormalSofa,
          width: 15.w,
          height: 15.w,
          fit: BoxFit.fill,
        ),
        if (user.id != -1)
          AppCircleNetImage(
            imageUrl: user.avatar,
            size: 52.w,
          )
      ],
    );
  }
}
