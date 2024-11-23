import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/modules/submod/rank/list/model/cp_rank_list_model.dart';
import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:flutter/material.dart';

class CpRankListItemWidget extends StatelessWidget {
  const CpRankListItemWidget(
      {super.key,
      required this.model,
      required this.index,
      required this.onClickUserItem,
      required this.onClickLiveItem,
      required this.mainTab});

  final int index;
  final CpRankModel model;
  final Function onClickUserItem;
  final Function onClickLiveItem;
  final TabModel mainTab;

  @override
  Widget build(BuildContext context) {
    return AppRow(
      onTap: () {
        onClickUserItem();
      },
      height: 80.h,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 10.w),
          width: 46.w,
          child: Text(
            index > 9 ? "$index" : "0$index",
            style: AppTheme()
                .textStyle(fontSize: 16.sp, color: AppTheme.colorTextWhite),
          ),
        ),
        AppStack(
            width: 99.w,
            height: 58.h,
            alignment: Alignment.bottomCenter,
            children: [
              Positioned(left: 0.w, child: _headWidget(model.userInfo!)),
              Positioned(right: 0.w, child: _headWidget(model.cpUserInfo!)),
            ]),
        SizedBox(
          width: 10.h,
        ),
        AppColumn(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          width: 100.w,
          children: [
            Text(model.userInfo?.nickname ?? "",
                style: AppTheme().textStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis)),
            Text(model.cpUserInfo?.nickname ?? "",
                style: AppTheme().textStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis)),
          ],
        ),
        const Spacer(),
        Text(
          '亲密度:${model.num!.split('.').first}',
          style: AppTheme().textStyle(fontSize: 12.sp, color: Colors.green),
        ),
        SizedBox(
          width: 14.w,
        )
      ],
    );
  }

  _headWidget(UserInfo user) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(99.w),
          border: Border.all(width: 2.w, color: Colors.white)),
      width: 58.w,
      height: 58.w,
      child: Align(
        child: AppCircleNetImage(
          imageUrl: user.avatar,
          size: 56.w,
        ),
      ),
    );
  }
}
