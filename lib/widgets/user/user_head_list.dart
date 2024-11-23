import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:flutter/material.dart';

import '../../../models/room_list_item_online_user.dart';

class UserHeadList extends StatelessWidget {
  const UserHeadList({super.key, required this.users});

  final List<RoomListItemOnlineUser> users;
  final int maxCount = 3;

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const SizedBox(
        width: 0,
      );
    }
    List<Widget> userItems = [];
    double itemW = 0;
    for (var i = 0; i < users.length; i++) {
      if (userItems.length < maxCount) {
        itemW = (i * 20.w - i * 6.w) + 20.w + 4.w;
        userItems.add(
          Positioned(
            top: 0,
            left: i == 0 ? 0 : (i * 20.w - i * 6.w),
            child: AppCircleNetImage(
              defaultWidget: AppTheme().defaultHeadImage(),
              imageUrl: users[i].avatar,
              size: 20.w,
              errorSize: 15.w,
              borderWidth: 1.w,
              borderColor: AppTheme.colorTextWhite,
            ),
          ),
        );
      } else {
        break;
      }
    }
    return SizedBox(
      width: itemW,
      height: 22.w,
      child: Stack(
        children: userItems,
      ),
    );
  }
}
