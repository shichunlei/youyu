import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/widgets/user/user_online_widget.dart';
import 'package:youyu/widgets/user/user_sex_age_widget.dart';
import 'package:youyu/widgets/user/user_tag_widget.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserDetailHeader extends StatelessWidget {
  const UserDetailHeader(
      {super.key,
      required this.height,
      this.targetUserInfo,
      required this.onClickHead});

  final double height;
  final UserInfo? targetUserInfo;
  final Function onClickHead;

  @override
  Widget build(BuildContext context) {
    return AppColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      width: double.infinity,
      height: height,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [_topContent(), _signContent(), _bottomContent()],
    );
  }

  ///顶部
  _topContent() {
    return AppRow(
      onTap: () {
        onClickHead();
      },
      width: double.infinity,
      padding: EdgeInsets.only(
          top: ScreenUtils.navbarHeight + ScreenUtils.statusBarHeight),
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //头像
        AppCircleNetImage(
          size: 76.h,
          imageUrl: targetUserInfo?.avatar ?? "",
          borderColor: AppTheme.colorTextWhite,
          borderWidth: 1.5.w,
        ),
        SizedBox(
          width: 14.w,
        ),
        //名称&性别&状态
        Expanded(
            child: AppColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppRow(
              children: [
                //昵称
                Text(
                  targetUserInfo?.nickname ?? "",
                  style: AppTheme().textStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.colorTextWhite),
                ),
                SizedBox(
                  width: 7.w,
                ),
                //性别
                UserSexAgeWidget(
                  gender: targetUserInfo?.gender,
                  age: 19,
                ),
                SizedBox(
                  width: 5.w,
                ),
                //状态
                if (targetUserInfo?.isOnline == true) const UserOnlineWidget()
              ],
            ),
            //标签
            if ((targetUserInfo?.userTagList ?? []).isNotEmpty)
              SizedBox(
                height: 8.h,
              ),
            if ((targetUserInfo?.userTagList ?? []).isNotEmpty)
              UserTagWidget(tagList: targetUserInfo?.userTagList ?? []),
            SizedBox(
              height: 8.h,
            ),
            //靓号
            AppRow(
              onTap: () {
                Clipboard.setData(
                    ClipboardData(text: '${targetUserInfo?.fancyNumber}'));
                ToastUtils.show('复制成功');
              },
              children: [
                if (targetUserInfo?.isHighFancyNum ?? false)
                  AppLocalImage(
                    path: AppResource().lh,
                    width: 16.w,
                  ),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  'ID:${targetUserInfo?.fancyNumber}',
                  style: AppTheme().textStyle(
                      fontSize: 12.sp, color: AppTheme.colorTextWhite),
                ),
                SizedBox(
                  width: 4.w,
                ),
                AppLocalImage(
                  path: AppResource().copy,
                  width: 10.w,
                  imageColor: AppTheme.colorTextWhite,
                ),
              ],
            ),
          ],
        ))
      ],
    );
  }

  _signContent() {
    return AppContainer(
      alignment: Alignment.centerLeft,
      height: 36.h + 25.h,
      child: Text(
        targetUserInfo?.signature?.isNotEmpty == true
            ? (targetUserInfo?.signature ?? "")
            : "暂无签名",
        maxLines: 2,
        style: AppTheme().textStyle(fontSize: 14.sp, color: AppTheme.colorTextWhite),
      ),
    );
  }

  _bottomContent() {
    return AppRow(
      children: [
        Text(
          '关注 ${targetUserInfo?.focusCount ?? 0}',
          style: AppTheme().textStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: AppTheme.colorTextWhite),
        ),
        SizedBox(
          width: 45.w,
        ),
        Text(
          '粉丝 ${targetUserInfo?.focusMeCount ?? 0}',
          style: AppTheme().textStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: AppTheme.colorTextWhite),
        )
      ],
    );
  }
}
