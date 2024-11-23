import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/widgets/image/stack_lock_image.dart';
import 'package:youyu/widgets/svga/simple_player_ext.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/room_list_item.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/utils/number_ext.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';

///热门交友
class RecommendMarkItem extends StatelessWidget {
  const RecommendMarkItem({super.key, required this.model});

  final RoomListItem model;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [_topWidget(), _bottomWidget()],
    );
  }

  _topWidget() {
    return Expanded(
      child: Stack(
        children: [
          StackLockImage(
            imageUrl: model.bigAvatar ?? "",
            isLock: model.lock == 1,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: double.infinity,
                height: 30.w,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    AppLocalImage(
                      path: AppResource().homeTag1,
                      height: 30.w,
                      fit: BoxFit.fitWidth,
                    ),
                    Positioned(
                        left: 8.w,
                        child: Text(
                          model.typeName ?? "",
                          style: AppTheme().textStyle(
                              fontSize: 14.sp,
                              color: AppTheme.colorTextWhite),
                        ))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 6.w, right: 6.w),
                decoration: BoxDecoration(
                  gradient: AppTheme().maskGradient,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(6.w),
                      bottomRight: Radius.circular(6.w)),
                ),
                height: 21.h,
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 15.w,
                      height: 15.w,
                      child: SVGASimpleImageExt(
                        assetsName: AppResource.getSvga('audio_list'),
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      (model.heat ?? 0).showNum(),
                      style: AppTheme().textStyle(
                          fontSize: 12.sp, color: AppTheme.colorMain),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _bottomWidget() {
    return SizedBox(
      height: 42.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppCircleNetImage(
            imageUrl: model.headAvatar ?? "",
            size: 22.w,
            borderWidth: 1.5.w,
            borderColor: AppTheme.colorMain,
          ),
          SizedBox(
            width: 5.w,
          ),
          Flexible(
              child: Text(
            model.name,
            style: AppTheme().textStyle(
                fontSize: 14.sp, color: AppTheme.colorTextWhite),
          ))
        ],
      ),
    );
  }
}
