import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/modules/submod/rank/list/model/cp_rank_list_model.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';

class CpRankListTopWidget extends StatelessWidget {
  const CpRankListTopWidget(
      {super.key,
      required this.list,
      required this.onClickUserItem,
      required this.onClickLiveItem,
      required this.mainTab});

  final List<CpRankModel> list;
  final Function(UserInfo model) onClickUserItem;
  final Function(UserInfo model) onClickLiveItem;
  final TabModel mainTab;

  @override
  Widget build(BuildContext context) {
    return AppStack(
      height: 289.h,
      children: [
        Positioned(
            left: 0,
            right: 0,
            top: 48.h,
            child: AppLocalImage(
              path: AppResource().rankCpTopBg,
              width: 346.5.w,
              height: 241.5.h,
            )),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 105.w),
              child: list.length > 1
                  ? _RankListTopItemWidget(
                      borderColor: const Color(0xFF9DB0C2),
                      model: list[1],
                      rankImg: AppResource().rankCp2,
                      onClickUserItem: onClickUserItem,
                      onClickLiveItem: onClickLiveItem,
                      mainTab: mainTab,
                    )
                  : SizedBox(
                      width: 99.w,
                      height: 76.h,
                    ),
            ),

            // ///第一个一定有
            _RankListTopItemWidget(
              borderColor: const Color(0xFFFCCB1D),
              model: list[0],
              rankImg: AppResource().rankCp1,
              onClickUserItem: onClickUserItem,
              onClickLiveItem: onClickLiveItem,
              mainTab: mainTab,
            ),
            Container(
              margin: EdgeInsets.only(top: 105.h),
              child: list.length > 2
                  ? _RankListTopItemWidget(
                      borderColor: const Color(0xFFE6BBAD),
                      model: list[2],
                      rankImg: AppResource().rankCp3,
                      onClickUserItem: onClickUserItem,
                      onClickLiveItem: onClickLiveItem,
                      mainTab: mainTab,
                    )
                  : SizedBox(
                      width: 99.w,
                      height: 76.h,
                    ),
            ),
          ],
        )
      ],
    );
  }
}

///item
class _RankListTopItemWidget extends StatelessWidget {
  const _RankListTopItemWidget(
      {required this.model,
      required this.borderColor,
      required this.rankImg,
      required this.onClickUserItem,
      required this.onClickLiveItem,
      required this.mainTab});

  final TabModel mainTab;
  final String rankImg;
  final Color borderColor;
  final CpRankModel model;
  final Function(UserInfo model) onClickUserItem;
  final Function(UserInfo model) onClickLiveItem;

  @override
  Widget build(BuildContext context) {
    return AppColumn(
      width: 99.w,
      onTap: () {},
      children: [
        AppStack(
            width: 99.w,
            height: 76.h,
            alignment: Alignment.bottomCenter,
            children: [
              Positioned(left: 0.w, child: _headWidget(model.userInfo!)),
              Positioned(right: 0.w, child: _headWidget(model.cpUserInfo!)),
              Positioned(
                top: 0.w,
                child: AppLocalImage(
                  path: rankImg,
                  width: 29.w,
                ),
              )
            ]),
        SizedBox(
          height: 8.h,
        ),
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
        SizedBox(
          height: 4.h,
        ),
        SizedBox(
          height: 4.h,
        ),
        Text(
          '亲密度:${model.num!.split('.').first}',
          style: AppTheme().textStyle(fontSize: 12.sp, color: borderColor),
        ),
        SizedBox(
          height: 4.h,
        ),
      ],
    );
  }

  _headWidget(UserInfo user) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(99.w),
          border: Border.all(width: 2.w, color: borderColor)),
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
