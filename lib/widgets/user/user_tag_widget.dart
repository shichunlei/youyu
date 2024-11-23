import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/models/localmodel/user_tag_model.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_round_container.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:flutter/material.dart';

class UserTagWidget extends StatelessWidget {
  const UserTagWidget({super.key, required this.tagList});

  final List<UserTagModel> tagList;

  @override
  Widget build(BuildContext context) {
    if (tagList.isEmpty) {
      return const SizedBox.shrink();
    }
    List<Widget> wList = [];
    for (UserTagModel value in tagList) {
      switch (value.type) {
        case UserTagType.vip:
          wList.add(_vipWidget(value));
          break;
        case UserTagType.sVip:
          wList.add(_svipWidget(value));
          break;
        case UserTagType.level:
          wList.add(_levelWidget(value));
          break;
        case UserTagType.nobility:
          wList.add(_nobilityWidget(value));
          break;
        case UserTagType.manger:
          wList.add(_managerWidget(value));
          break;
      }
    }

    return Wrap(
      //主轴上子控件的间距
      runSpacing: 5.w,
      crossAxisAlignment: WrapCrossAlignment.center,
      //交叉轴上子控件之间的间距
      spacing: 4.w,
      children: wList,
    );
  }

  /*
  _nobilityWidget(UserTagModel model) {
    return SizedBox(
        height: 21.h,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              padding: EdgeInsets.only(left: 20.w, right: 4.w),
              height: 18.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99.w),
                  gradient: model.nobility?.bgGradient),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    model.nobility?.name ?? "",
                    style: AppTheme().textStyle(
                        fontSize: 9.sp, color: AppTheme.colorTextWhite),
                  )
                ],
              ),
            ),
            AppNetImage(
              imageUrl: model.nobility?.img ?? "",
              width: 21.w,
              height: 21.w,
              defaultWidget: const SizedBox.shrink(),
            ),
          ],
        ));
  }
   */

  _nobilityWidget(UserTagModel model) {
    return SizedBox(
      height: 21.h,
      child: AppNetImage(
        imageUrl: model.nobility?.img ?? "",
        width: 21.w,
        height: 21.w,
        fit: BoxFit.contain,
        defaultWidget: const SizedBox.shrink(),
      ),
    );
  }

  _vipWidget(UserTagModel model) {
    return AppLocalImage(
      path: AppResource().vip,
      height: 18.h,
      fit: BoxFit.fitHeight,
    );
  }

  _svipWidget(UserTagModel model) {
    return AppLocalImage(
      path: AppResource().svip,
      height: 18.h,
      fit: BoxFit.fitHeight,
    );
  }

  _levelWidget(UserTagModel model) {
    return AppStack(
      width: 40.w,
      height: 20.w,
      alignment: Alignment.centerRight,
      children: [
        AppNetImage(
          imageUrl: model.level?.img ?? "",
          width: 36.w,
          height: 20.w,
          defaultWidget: const SizedBox.shrink(),
        ),
        Container(
          padding: EdgeInsets.only(right: _levelTextRight(model)),
          child: Text(
            (model.level?.curLevel ?? 0).toString(),
            style: AppTheme().textStyle(
                fontSize: 9.sp, color: AppTheme.colorTextWhite),
          ),
        )
      ],
    );
  }

  _levelTextRight(UserTagModel model) {
    String level = ((model.level?.curLevel ?? 0).toString());
    if (level.length == 1) {
      return 9.w;
    } else if (level.length == 2) {
      return 5.w;
    } else {
      return 2.w;
    }
  }

  _managerWidget(UserTagModel model) {
    return AppRoundContainer(
        alignment: Alignment.center,
        gradient: AppTheme().liveManagerGradient,
        width: 36.w,
        padding: EdgeInsets.zero,
        height: 18.h,
        child: Text(
          "管理",
          style: AppTheme().textStyle(
              fontSize: 10.sp, color: AppTheme.colorTextWhite),
        ));
  }
}
