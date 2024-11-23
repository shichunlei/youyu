import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'live_info_widget.dart';
import 'live_user_count_widget.dart';

///直播间导航栏
class LiveNavBar extends StatelessWidget implements PreferredSizeWidget {
  const LiveNavBar(
      {super.key,
      required this.roomName,
      required this.liveFancyNumber,
      required this.liveHot,
      required this.top3UserList,
      required this.onlineUserList,
      required this.onClickUserList,
      required this.onClickTopMore,
      required this.isFocus,
      required this.onClickLiveFocus,
      required this.roomType,
      required this.isLock});

  ///房间id
  final int liveFancyNumber;

  ///房间名称
  final Rx<String> roomName;

  ///房间类型
  final Rx<String> roomType;

  ///热度
  final Rx<String> liveHot;

  ///是否关注
  final Rx<int> isFocus;

  ///是否加锁
  final Rx<int> isLock;

  /// 前三用户
  final RxList<UserInfo> top3UserList;

  /// 在线用户
  final RxList<UserInfo> onlineUserList;

  final Function onClickUserList;
  final Function onClickTopMore;
  final Function onClickLiveFocus;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      color: Colors.transparent,
      width: double.infinity,
      height: ScreenUtils.navbarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              child: LiveInfoWidget(
            roomName: roomName,
            roomType: roomType,
            liveFancyNumber: liveFancyNumber,
            liveHot: liveHot,
            isFocus: isFocus,
            onLiveFocus: onClickLiveFocus,
            isLock: isLock,
          )),
          LiveUserCountWidget(
            top3UserList: top3UserList,
            onlineUserList: onlineUserList,
            onClickUserList: onClickUserList,
            onClickTopMore: onClickTopMore,
          )
        ],
      ),
    ));
  }

  @override
  Size get preferredSize => Size.fromHeight(ScreenUtils.navbarHeight);
}
