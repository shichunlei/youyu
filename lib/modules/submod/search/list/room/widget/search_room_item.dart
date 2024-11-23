import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/widgets/image/stack_lock_image.dart';
import 'package:youyu/widgets/svga/simple_player_ext.dart';
import 'package:youyu/widgets/user/user_head_list.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/room_list_item.dart';
import 'package:youyu/config/resource.dart';
import 'package:flutter/material.dart';

class SearchRoomItem extends StatelessWidget {
  const SearchRoomItem({super.key, required this.model});

  final RoomListItem model;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 82.h,
      child: Row(
        children: [
          Stack(
            children: [
              StackLockImage(
                  width: 82.h,
                  height: 82.h,
                  imageUrl: model.bigAvatar ?? "",
                  isLock: model.lock == 1),
              Positioned(
                right: 6.w,
                bottom: 6.w,
                child: SizedBox(
                  width: 15.w,
                  height: 15.w,
                  child: SVGASimpleImageExt(
                    assetsName: AppResource.getSvga('audio_list'),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            width: 14.w,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                model.name,
                style: AppTheme().textStyle(
                    fontSize: 14, color: AppTheme.colorTextWhite),
              ),
              SizedBox(
                height: 8.h,
              ),
              Text(
                "ID：${model.fancyNumber}",
                style: AppTheme().textStyle(
                    fontSize: 14.sp, color: AppTheme.colorTextSecond),
              ),
              SizedBox(
                height: 8.h,
              ),
              _bottom()
            ],
          ))
        ],
      ),
    );
  }

  ///底部
  _bottom() {
    return SizedBox(
      width: double.infinity,
      height: 24.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UserHeadList(users: model.onlineUserList),
                  SizedBox(
                    width: 2.w,
                  ),
                  model.onlineUserList.isNotEmpty
                      ? Expanded(
                          child: Text(
                            "${model.onlineUserList.length}人",
                            style: AppTheme().textStyle(
                                fontSize: 12, color: AppTheme.colorMain),
                          ),
                        )
                      : Container()
                ],
              )),
        ],
      ),
    );
  }
}
