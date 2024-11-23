import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/widgets/image/stack_lock_image.dart';
import 'package:youyu/widgets/svga/simple_player_ext.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/room_list_item.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/utils/number_ext.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:flutter/material.dart';

class HomeTypeSubItem extends StatelessWidget {
  const HomeTypeSubItem({super.key, required this.model});

  final RoomListItem model;

  @override
  Widget build(BuildContext context) {
    return AppColumn(
      color: AppTheme.colorDarkBg,
      radius: 10.w,
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
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.w),
                topRight: Radius.circular(10.w)),
          ),
          AppRow(
            width: double.infinity,
            height: 39.h,
            padding: EdgeInsets.only(left: 8.w, right: 8.w),
            topLeftRadius: 10.w,
            topRightRadius: 10.w,
            gradient: AppTheme().maskReverseGradient,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 24.w,
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.w),
                  color: const Color(0x33FFFFFF),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      model.typeName ?? "",
                      style: AppTheme().textStyle(
                          fontSize: 14.sp,
                          color: AppTheme.colorTextWhite),
                    )
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Row(
            children: [
              SizedBox(
                width: 5.w,
              ),
              AppCircleNetImage(
                imageUrl: model.headAvatar ?? "",
                size: 16.w,
                errorSize: 10.w,
                borderWidth: 1.5.w,
                borderColor: AppTheme.colorMain,
              ),
              SizedBox(
                width: 5.w,
              ),
              Expanded(
                child: Text(
                  model.name,
                  style: AppTheme().textStyle(
                      fontSize: 14.sp, color: AppTheme.colorTextWhite),
                ),
              )
            ],
          )),
          AppRow(
            padding: EdgeInsets.only(left: 6.w, right: 5.w),
            height: 31.h,
            alignment: Alignment.centerRight,
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
          )
        ],
      ),
    );
  }
}
