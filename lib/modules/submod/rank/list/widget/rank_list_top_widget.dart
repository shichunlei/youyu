import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/widgets/svga/simple_player_ext.dart';
import 'package:youyu/widgets/user/user_info_widget.dart';
import 'package:youyu/widgets/user/user_tag_widget.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';

class RankListTopWidget extends StatelessWidget {
  const RankListTopWidget(
      {super.key,
      required this.list,
      required this.onClickUserItem,
      required this.onClickLiveItem,
      required this.mainTab});

  final List<UserInfo> list;
  final Function(UserInfo model) onClickUserItem;
  final Function(UserInfo model) onClickLiveItem;
  final TabModel mainTab;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 227.h,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0],
              colors: [Colors.transparent, Color(0xFF526112)],
            )),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Container(
              margin: EdgeInsets.only(top: 24.h),
              child: list.length > 1
                  ? _RankListTopItemWidget(
                      borderColor: const Color(0xFF9DB0C2),
                      model: list[1],
                      rankImg: AppResource().rank2,
                      onClickUserItem: onClickUserItem,
                      onClickLiveItem: onClickLiveItem,
                      mainTab: mainTab,
                    )
                  : const SizedBox(
                      width: 1,
                      height: 1,
                    ),
            )),

            ///第一个一定有
            Expanded(
                child: _RankListTopItemWidget(
              borderColor: const Color(0xFFFCCB1D),
              model: list[0],
              rankImg: AppResource().rank1,
              onClickUserItem: onClickUserItem,
              onClickLiveItem: onClickLiveItem,
              mainTab: mainTab,
            )),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(top: 24.h),
              child: list.length > 2
                  ? _RankListTopItemWidget(
                      borderColor: const Color(0xFFE6BBAD),
                      model: list[2],
                      rankImg: AppResource().rank3,
                      onClickUserItem: onClickUserItem,
                      onClickLiveItem: onClickLiveItem,
                      mainTab: mainTab,
                    )
                  : const SizedBox(
                      width: 1,
                      height: 1,
                    ),
            )),
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
  final UserInfo model;
  final Function(UserInfo model) onClickUserItem;
  final Function(UserInfo model) onClickLiveItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppColumn(
          onTap: () {
            onClickUserItem(model);
          },
          children: [
            _headWidget(),
            SizedBox(
              height: 8.h,
            ),
            UserInfoWidget(
              isHighFancyNum: model.isHighFancyNum,
              name: model.nickname ?? "",
              sex: model.gender,
            ),
            SizedBox(
              height: 4.h,
            ),
            UserTagWidget(tagList: model.userTagList),
            SizedBox(
              height: 4.h,
            ),
            Text(
              "ID：${model.fancyNumber}",
              style: AppTheme()
                  .textStyle(fontSize: 14.sp, color: AppTheme.colorMain),
            ),
            SizedBox(
              height: 4.h,
            ),
          ],
        ),
        _bottomNumWidget(),
        if (model.isPlay) _bottomWidget(),
        //占位
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }

  _headWidget() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99.w),
              border: Border.all(width: 1.5.w, color: borderColor)),
          width: 78.w,
          height: 78.w,
          child: Align(
            child: AppCircleNetImage(
              imageUrl: model.avatar,
              size: 66.w,
            ),
          ),
        ),
        AppLocalImage(
          path: rankImg,
          width: 26.w,
        )
      ],
    );
  }

  _bottomWidget() {
    return AppRow(
      margin: EdgeInsets.only(top: 4.h),
      onTap: () {
        onClickLiveItem(model);
      },
      height: 24.h,
      padding: EdgeInsets.only(left: 8.w, right: 8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.w),
        color: AppTheme.colorMain,
      ),
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 8.w,
          height: 8.w,
          child: SVGASimpleImageExt(
            assetsName: AppResource.getSvga('audio_list_white'),
          ),
        ),
        SizedBox(
          width: 6.w,
        ),
        Text(
          "踩房间",
          style: AppTheme()
              .textStyle(fontSize: 14.sp, color: AppTheme.colorTextWhite),
        )
      ],
    );
  }

  _bottomNumWidget() {
    return AppRow(
      mainAxisAlignment: MainAxisAlignment.center,
      margin: EdgeInsets.only(right: 12.w, left: 8.w),
      children: [
        AppLocalImage(
          path: mainTab.id == 2 ? AppResource().coin1 : AppResource().coin2,
          width: 10.w,
        ),
        SizedBox(
          width: 3.w,
        ),
        Text(
          model.numCoin ?? "0",
          style: AppTheme()
              .textStyle(fontSize: 12.sp, color: AppTheme.colorTextWhite),
        )
      ],
    );
  }
}
