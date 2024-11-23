import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/widgets/image/stack_lock_image.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/room_list_item.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';

class SinglePlayItem extends StatelessWidget {
  const SinglePlayItem(
      {super.key,
      required this.model,
      required this.lockSize,
      required this.isShowTag});

  final RoomListItem model;
  final double lockSize;
  final bool isShowTag;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StackLockImage(imageUrl: model.bigAvatar ?? "", isLock: model.lock == 1,lockWidth: lockSize,lockHeight: lockSize,),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(left: 6.w, right: 6.w),
              decoration: BoxDecoration(
                gradient: AppTheme().maskGradient,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(6.w),
                    bottomRight: Radius.circular(6.w)),
              ),
              height: 21.h,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      model.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme().textStyle(
                          fontSize: 12.sp,
                          color: AppTheme.colorTextWhite),
                    ),
                  )
                ],
              ),
            )),
        if (isShowTag)
          Positioned(
              top: 8.w,
              right: 8.w,
              child: AppLocalImage(
                path: AppResource().homeFirstTag,
                width: 34.w,
              ))
      ],
    );
  }
}
