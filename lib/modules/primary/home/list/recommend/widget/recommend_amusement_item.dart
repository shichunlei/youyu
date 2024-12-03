import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';

import 'package:youyu/widgets/image/stack_lock_image.dart';
// import 'package:youyu/widgets/svga/simple_player_ext.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/room_list_item.dart';
import 'package:youyu/config/resource.dart';
// import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:flutter/material.dart';
import 'package:youyu/utils/number_ext.dart';

///热门娱乐
class RecommendAmusementItem extends StatelessWidget {
  const RecommendAmusementItem({super.key, required this.model});

  final RoomListItem model;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.colorWhiteBg,
        borderRadius: BorderRadius.all(Radius.circular(13.w)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 5.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [_topWidget(), _bottomWidget()],
      ),
    );
  }

  _topWidget() {
    return Expanded(
      child: Stack(
        children: [
          StackLockImage(
            imageUrl: model.bigAvatar ?? "",
            isLock: model.lock == 1,
            borderRadius: BorderRadius.all(Radius.circular(13.w)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 46.2.w,
                    height: 23.8.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(13.w),
                            bottomRight: Radius.circular(13.w)),
                        gradient: AppTheme().roomTagGradient),
                    child: Center(
                      child: Text(
                        model.typeName ?? "",
                        style: AppTheme().textStyle(
                            fontSize: 14.sp, color: AppTheme.colorTextWhite),
                      ),
                    ),
                  ),
                  Container(
                    width: 61.6.w,
                    height: 21.w,
                    padding: EdgeInsets.only(right: 6.w),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(13.w)),
                      gradient: AppTheme().roomUserGradient,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppLocalImage(
                          path: AppResource().homeRoomUser,
                          width: 10.w,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          (model.onlineUserCount ?? 0).showNum(),
                          style: AppTheme().textStyle(
                              fontSize: 14.sp, color: AppTheme.colorTextWhite),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 8.h),
                decoration: BoxDecoration(
                  gradient: AppTheme().roomHeatGradient,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(13.w)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 56.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppLocalImage(
                            path: AppResource().homeRoomHeat,
                            width: 14.w,
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          Expanded(
                            child: Text(
                              (model.heat ?? 0).showNum(),
                              style: AppTheme().textStyle(
                                  fontSize: 14.sp,
                                  color: AppTheme.colorTextWhite),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          model.roomCreateNickname ?? "",
                          style: AppTheme().textStyle(
                              fontSize: 14.sp,
                              color: AppTheme.colorTextWhite,
                              overflow: TextOverflow.ellipsis),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _bottomWidget() {
    return SizedBox(
      height: 32.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
              child: Text(
            model.name,
            style: AppTheme()
                .textStyle(fontSize: 14.sp, color: AppTheme.colorTextDark),
          ))
        ],
      ),
    );
  }
}
