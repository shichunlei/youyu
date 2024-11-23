/*
 * @Author: alexalive hhyy1243047559@gmail.com
 * @Date: 2024-11-06 18:17:26
 * @LastEditors: alexalive hhyy1243047559@gmail.com
 * @LastEditTime: 2024-11-07 23:16:17
 * @FilePath: /youyu/lib/modules/submod/user/detail/sub/relation/widget/user_relation_card_widget.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'dart:math';

import 'package:youyu/config/resource.dart';
import 'package:youyu/modules/live/common/interactor/pop/user/Relation_Model.dart';
import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/utils/time_utils.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:flutter/material.dart';

class UserRelationCardWidget extends StatelessWidget {
  const UserRelationCardWidget(
      {super.key,
      required this.relationCard,
      required this.onClick,
      required this.index});

  final RelationList relationCard;
  final Function onClick;
  final int index;

  @override
  Widget build(BuildContext context) {
    return AppStack(
      children: [
        AppContainer(
          // color: const Color(0xFF1E1E1E),
          child: AppLocalImage(
            path: AppResource.getDynamicRelationCard(Random().nextInt(6)),
            fit: BoxFit.fitHeight,
          ),
        ),
        Center(
          child: AppColumn(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            // color: const Color(0xFF1E1E1E),
            radius: 8.w,
            onTap: () {
              onClick();
            },
            children: [
              AppNetImage(
                imageUrl: relationCard.textImg,
                height: 16.5.h,
              ),
              SizedBox(
                height: 8.h,
              ),
              AppCircleNetImage(
                // width: double.infinity,
                size: 35.h,
                imageUrl: relationCard.avatar,
                // fit: BoxFit.contain,
                defaultWidget: const SizedBox.shrink(),
              ),
              SizedBox(
                height: 8.h,
              ),
              Opacity(
                opacity: 0.7,
                child: Text(
                  "${relationCard.nickname}",
                  style: AppTheme().textStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.colorTextWhite),
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              Opacity(
                opacity: 0.7,
                child: Text(
                  TimeUtils.getRemainingTime(relationCard.endTime!),
                  style: AppTheme().textStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.colorTextWhite),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
