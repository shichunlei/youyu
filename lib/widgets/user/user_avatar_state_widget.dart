import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/svga/simple_player_ext.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/icon/app_un_read_icon.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:flutter/material.dart';

class UserAvatarStateWidget extends StatelessWidget {
  const UserAvatarStateWidget(
      {super.key,
      required this.userInfo,
      required this.avatar,
      required this.size,
      this.borderWidth,
      this.borderColor,
      this.unreadCount,
      this.onClickUserHead});

  ///头像
  final String? avatar;

  ///用户信息
  final UserInfo? userInfo;

  ///大小
  final double size;

  ///边框宽
  final double? borderWidth;

  ///边框颜色
  final Color? borderColor;

  ///消息未读
  final int? unreadCount;

  final Function(UserInfo? userInfo)? onClickUserHead;

  @override
  Widget build(BuildContext context) {
    return AppStack(
      width: size,
      height: size,
      onTap: _onClickHead,
      alignment: Alignment.center,
      children: [
        AppCircleNetImage(
          imageUrl: avatar ?? '',
          size: size,
          borderWidth: borderWidth,
          borderColor: borderColor,
        ),
        (unreadCount ?? 0) > 0
            ? Positioned(
                top: 0,
                right: 0,
                child: AppUnReadIcon(
                  number: unreadCount ?? 0,
                ),
              )
            : const SizedBox(),

        ///在线
        if (userInfo?.isOnline == true && !((userInfo?.onlineRoom ?? 0) > 0))
          Positioned(
            right: 5.w,
            bottom: 8.w,
            child: AppContainer(
              radius: 12.w,
              color: AppTheme.colorMain,
              width: 6.w,
              height: 6.w,
            ),
          ),

        ///在直播
        if ((userInfo?.onlineRoom ?? 0) > 0)
          Positioned(
              bottom: 4.h,
              child: SizedBox(
                width: 8.w,
                height: 8.w,
                child: SVGASimpleImageExt(
                  assetsName: AppResource.getSvga('audio_list'),
                ),
              ))
      ],
    );
  }

  _onClickHead() {
    if (onClickUserHead != null) {
      onClickUserHead!(userInfo);
    } else {
      if ((userInfo?.onlineRoom ?? 0) > 0) {
        //TODO:直播间内不跳转
        if (!LiveService().isInLive) {
          LiveService().pushToLive(
              userInfo?.thisRoomInfo?.id, userInfo?.thisRoomInfo?.groupId);
        }
      } else {
        UserController.to.pushToUserDetail(userInfo?.id, UserDetailRef.other);
      }
    }
    return null;
  }
}
