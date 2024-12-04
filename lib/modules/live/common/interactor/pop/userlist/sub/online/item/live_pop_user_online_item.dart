import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/user/user_info_widget.dart';
import 'package:youyu/widgets/user/user_tag_widget.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';


class LivePopUserOnLineItem extends StatelessWidget {
  const LivePopUserOnLineItem(
      {super.key,
      required this.index,
      required this.model,
      this.onClickMore,
      required this.isOwner,
      required this.isManager});

  final int index;
  final bool isOwner;
  final bool isManager;
  final UserInfo model;
  final Function? onClickMore;

  @override
  Widget build(BuildContext context) {
    return AppRow(
      onTap: () {
        UserController.to.pushToUserDetail(model.id, UserDetailRef.live);
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
        if (model.id != UserController.to.id && (isOwner || isManager))
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
          viewType: UserInfoViewType.light,
          isHighFancyNum: model.isHighFancyNum,
          name: model.nickname ?? "",
          sex: model.gender,
          userType: model.isManage == 1 ? "管理" : null,
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

  //判断权限
  _rightWidget() {
    return InkWell(
      onTap: () {
        if (onClickMore != null) {
          onClickMore!();
        }
      },
      child: Container(
        padding: EdgeInsets.only(left: 13.w),
        child: Center(
          child: AppLocalImage(
            path: AppResource().liveMore,
            width: 4.w,
            height: 18.h,
          ),
        ),
      ),
    );
  }
}
