import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/widgets/user/user_info_widget.dart';
import 'package:youyu/widgets/user/user_tag_widget.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';

class LivePopUserRankSubItem extends StatelessWidget {
  const LivePopUserRankSubItem(
      {super.key,
      required this.index,
      required this.model,
      required this.mainTab});

  final int index;
  final TabModel? mainTab;
  final UserInfo model;

  @override
  Widget build(BuildContext context) {
    return AppRow(
      height: 80.h,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          width: 42.w,
          child: Text(
            "${index + 1}",
            style: AppTheme().textStyle(
                fontFamily: 'ys',
                fontSize: 16.sp,
                color: mainTab?.id == 1
                    ? AppTheme.colorMain
                    : const Color(0xFFFFCC00)),
          ),
        ),
        AppCircleNetImage(
          imageUrl: model.avatar,
          size: 56.w,
          borderColor: AppTheme.colorTextWhite,
          borderWidth: 1.w,
        ),
        SizedBox(
          width: 6.h,
        ),
        Expanded(child: _centerWidget()),
        _rightWidget()
      ],
    );
  }

  _centerWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        UserInfoWidget(
          isHighFancyNum: model.isHighFancyNum,
          name: model.nickname ?? "",
          sex: model.gender,
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          "ID：${model.fancyNumber}",
          style: AppTheme().textStyle(
              fontSize: 14.sp, color: AppTheme.colorTextSecond),
        ),
        SizedBox(
          height: 2.h,
        ),
        UserTagWidget(tagList: model.userTagList)
      ],
    );
  }

  _rightWidget() {
    return AppRow(
      margin: EdgeInsets.only(right: 12.w),
      children: [
        AppLocalImage(
          path: mainTab?.id == 2
              ? AppResource().coin1
              : AppResource().coin2,
          width: 10.w,
        ),
        SizedBox(width: 3.w,),
        Text(
          model.numCoin ?? "0",
          style: AppTheme().textStyle(
              fontSize: 12.sp, color: AppTheme.colorTextWhite),
        )
      ],
    );
  }
}
