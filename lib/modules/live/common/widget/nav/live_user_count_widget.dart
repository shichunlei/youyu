import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_round_container.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../models/my_getuserinfo.dart';

class LiveUserCountWidget extends StatelessWidget {
  const LiveUserCountWidget(
      {super.key,
      required this.top3UserList,
      required this.onlineUserList,
      required this.onClickUserList,
      required this.onClickTopMore});

  /// 前三用户
  final RxList<UserInfo> top3UserList;

  /// 在线用户
  final RxList<UserInfo> onlineUserList;

  final Function onClickUserList;
  final Function onClickTopMore;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Obx(
          () => InkWell(
            onTap: () {
              onClickUserList();
            },
            child: _userListWidget(top3UserList),
          ),
        ),
        InkWell(
          onTap: () {
            onClickTopMore();
          },
          child: Container(
            padding: EdgeInsets.only(left: 13.w, right: 10.w),
            child: Center(
              child: AppLocalImage(
                path: AppResource().liveMore,
                width: 4.w,
                height: 18.h,
              ),
            ),
          ),
        )
      ],
    );
  }

  ///top3用户列表 & 在线人数
  _userListWidget(List<UserInfo> list) {
    if (list.isEmpty) {
      return _emptyListWidget();
    }
    List<Widget> userWidget = [];
    for (int i = 0; i < list.length; i++) {
      UserInfo userInfo = list[i];
      Color borderColor = const Color(0xFFFCCB1D);
      if (i == 0) {
        borderColor = const Color(0xFFFCCB1D);
      } else if (i == 1) {
        borderColor = const Color(0xFF9DB0C2);
      } else if (i == 2) {
        borderColor = const Color(0xFFE6BBAD);
      }
      userWidget.add(_headWidget(borderColor, userInfo.avatar ?? ""));
      userWidget.add(SizedBox(
        width: 4.w,
      ));
    }
    //再次增加边距
    userWidget.add(SizedBox(
      width: 3.w,
    ));
    //在线人数
    userWidget.add(Obx(() => Text(
          "${onlineUserList.length}人",
          style: AppTheme().textStyle(fontSize: 9.sp, color: AppTheme.colorTextWhite),
        )));

    return Container(
      height: 30.h,
      padding: EdgeInsets.only(left: 8.w, right: 4.5.w),
      decoration: BoxDecoration(
        color: const Color(0x33FFFFFF),
        borderRadius: BorderRadius.circular(20.h),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: userWidget,
      ),
    );
  }

  //没有top3的情况
  _emptyListWidget() {
    return AppRoundContainer(
        bgColor: const Color(0x33FFFFFF),
        alignment: Alignment.center,
        height: 30.h,
        child: Obx(() => Text(
              "${onlineUserList.length}人",
              style: AppTheme().textStyle(
                  fontSize: 9.sp, color: AppTheme.colorTextWhite),
            )));
  }

  //头像
  _headWidget(Color borderColor, String avatar) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(99.w),
          border: Border.all(width: 1.5.w, color: borderColor)),
      width: 24.w,
      height: 24.w,
      child: Align(
        child: AppCircleNetImage(
          errorSize: 10.w,
          imageUrl: avatar,
          size: 22.w,
        ),
      ),
    );
  }
}
