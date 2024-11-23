import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/widgets/user/user_avatar_state_widget.dart';
import 'package:youyu/widgets/user/user_info_widget.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:flutter/material.dart';

class FriendListItem extends StatelessWidget {
  const FriendListItem(
      {super.key,
      required this.userInfo,
      required this.onClickItem,
      required this.onClickLive});

  final UserInfo userInfo;
  final Function(UserInfo userInfo)? onClickLive;
  final Function onClickItem;

  @override
  Widget build(BuildContext context) {
    return AppRow(
      onTap: () {
        onClickItem();
      },
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      height: 77.h,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _itemHeader(),
        SizedBox(
          width: 8.h,
        ),
        Expanded(child: _centerWidget()),
      ],
    );
  }

  _itemHeader() {
    return UserAvatarStateWidget(
      avatar: userInfo.avatar ?? '',
      size: 48.w,
      userInfo: userInfo,
    );
  }

  _centerWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        UserInfoWidget(
          isHighFancyNum: userInfo.isHighFancyNum,
          name: userInfo.nickname ?? "",
          sex: userInfo.gender,
        ),
        if (userInfo.signature?.isNotEmpty == true)
          SizedBox(
            height: 3.h,
          ),
        if (userInfo.signature?.isNotEmpty == true)
          Text(
            userInfo.signature ?? "",
            style: AppTheme().textStyle(
                fontSize: 12.sp, color: AppTheme.colorTextSecond),
          )
      ],
    );
  }
}
