import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/widgets/user/user_avatar_state_widget.dart';
import 'package:youyu/widgets/user/user_info_widget.dart';
import 'package:youyu/widgets/user/user_tag_widget.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:flutter/material.dart';

class SearchUserItem extends StatelessWidget {
  const SearchUserItem(
      {super.key, required this.model, required this.onClickFocus});

  final UserInfo model;
  final Function(UserInfo model) onClickFocus;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _headImage(),
          SizedBox(
            width: 8.h,
          ),
          Expanded(child: _centerWidget()),
          _rightWidget()
        ],
      ),
    );
  }

  _headImage() {
    return UserAvatarStateWidget(
      avatar: model.avatar ?? '',
      size: 61.w,
      userInfo: model,
    );
  }

  _centerWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        UserInfoWidget(
          isHighFancyNum: model.isHighFancyNum,
          name: model.nickname ?? "",
          sex: model.gender, viewType: UserInfoViewType.dark,
        ),
        Text(
          "ID：${model.fancyNumber}",
          style: AppTheme().textStyle(
              fontSize: 14.sp, color: AppTheme.colorTextSecond),
        ),
        //用户标签
        UserTagWidget(tagList: model.userTagList)
      ],
    );
  }

  _rightWidget() {
    return AppColorButton(
      title: model.isFocus ? "取消关注" : "关注",
      padding: EdgeInsets.zero,
      width: 64.w,
      fontSize: 12.sp,
      height: 23.h,
      titleColor: AppTheme.colorTextWhite,
      bgGradient: model.isFocus
          ? AppTheme().btnLightGradient
          : AppTheme().btnGradient,
      onClick: () {
        onClickFocus(model);
      },
    );
  }
}
