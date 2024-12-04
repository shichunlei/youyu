import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';

import 'package:youyu/widgets/svga/simple_player_ext.dart';
import 'package:youyu/widgets/user/user_info_widget.dart';
import 'package:youyu/widgets/user/user_tag_widget.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:flutter/material.dart';

class RankListItemWidget extends StatelessWidget {
  const RankListItemWidget({
    super.key,
    required this.model,
    required this.index,
    required this.onClickUserItem,
    required this.onClickLiveItem,
    required this.mainTab,
    this.subTab,
  });

  final int index;
  final UserInfo model;
  final Function onClickUserItem;
  final Function onClickLiveItem;
  final TabModel mainTab;
  final TabModel? subTab;

  @override
  Widget build(BuildContext context) {
    int adjustedIndex = mainTab.id == 4 ? index - 2 : index;
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
            adjustedIndex > 9 ? "$adjustedIndex" : "0$adjustedIndex",
            style: AppTheme()
                .textStyle(fontSize: 16.sp, color: AppTheme.colorTextWhite),
          ),
        ),
        AppCircleNetImage(
          imageUrl: model.avatar,
          size: 56.w,
          borderWidth: 1.w,
          borderColor: AppTheme.colorMain,
        ),
        SizedBox(
          width: 6.h,
        ),
        Expanded(child: _centerWidget()),
        if (model.isPlay) _rightWidget(),
        mainTab.id == 4 ? _rightNumWidget2() : _rightNumWidget(),
        SizedBox(
          width: 12.w,
        ),
      ],
    );
  }

  _centerWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        UserInfoWidget(
          viewType: UserInfoViewType.light,
          isHighFancyNum: model.isHighFancyNum,
          name: model.nickname ?? "",
          sex: model.gender,
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          "ID：${model.fancyNumber}",
          style: AppTheme()
              .textStyle(fontSize: 14.sp, color: AppTheme.colorTextSecond),
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
      onTap: () {
        onClickLiveItem();
      },
      height: 24.h,
      padding: EdgeInsets.only(left: 8.w, right: 8.w),
      radius: 6.w,
      color: const Color(0xFF4D6F40),
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 8.w,
          height: 8.w,
          child: SVGASimpleImageExt(
            assetsName: AppResource.getSvga('audio_list'),
          ),
        ),
        SizedBox(
          width: 6.w,
        ),
        Text(
          "踩房间",
          style:
              AppTheme().textStyle(fontSize: 14.sp, color: AppTheme.colorMain),
        )
      ],
    );
  }

  _rightNumWidget() {
    return AppRow(
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

  _rightNumWidget2() {
    return AppColumn(
      margin: EdgeInsets.only(right: 12.w, left: 8.w),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppNetImage(
          imageUrl: subTab?.image,
          width: 22.w,
        ),
        SizedBox(
          width: 3.w,
        ),
        Text(
          model.signature ?? "0",
          style: AppTheme()
              .textStyle(fontSize: 12.sp, color: AppTheme.colorTextWhite),
        )
      ],
    );
  }
}
