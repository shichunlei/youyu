import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/user/user_info_widget.dart';
import 'package:youyu/widgets/user/user_tag_widget.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';


class DiscoverPopUserItem extends StatelessWidget {
  const DiscoverPopUserItem(
      {super.key,
      required this.index,
      required this.model,
      required this.isSel,
      required this.onClickItem});

  final int index;
  final UserInfo model;
  final bool isSel;

  final Function onClickItem;

  @override
  Widget build(BuildContext context) {
    return AppRow(
      onTap: () {
        onClickItem();
      },
      margin: EdgeInsets.only(left: 20.w, right: 20.w),
      height: 82.h,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppCircleNetImage(
          borderWidth: 1.w,
          borderColor: Colors.white,
          imageUrl: model.avatar,
          size: 56.w,
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
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(left: 13.w),
        child: Center(
          child: AppLocalImage(
            path: isSel ? AppResource().sel : AppResource().unSel,
            width: 20.w,
            height: 20.w,
          ),
        ),
      ),
    );
  }
}
