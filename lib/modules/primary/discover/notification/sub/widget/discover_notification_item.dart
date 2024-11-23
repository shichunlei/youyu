import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/time_utils.dart';

import 'package:youyu/models/localmodel/notification_model.dart';
import 'package:youyu/widgets/user/user_info_widget.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/dynamic_controller.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:flutter/material.dart';

class DiscoverNotificationItem extends StatelessWidget {
  const DiscoverNotificationItem({
    super.key,
    required this.model,
    required this.tabId,
  });

  final NotificationModel model;
  final int tabId;

  @override
  Widget build(BuildContext context) {
    return AppRow(
      onTap: () {
        DynamicController.to.onClickDetail(null, dId: model.dynamicId);
      },
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
      children: [
        // 头像
        AppStack(
          alignment: Alignment.bottomCenter,
          children: [
            AppCircleNetImage(
              imageUrl: model.userInfo?.avatar ?? "",
              size: 48.w,
            ),
          ],
        ),
        // 昵称&时间
        SizedBox(
          width: 10.w,
        ),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserInfoWidget(
              isHighFancyNum: model.userInfo?.isHighFancyNum ?? false,
              name: model.userInfo?.nickname ?? "",
              sex: model.userInfo?.gender,
            ),
            SizedBox(
              height: 5.h,
            ),
            _tipText()
          ],
        )),
        Text(
          TimeUtils.displayTime(model.createTime ?? 0),
          style: AppTheme().textStyle(
              fontSize: 12.sp, color: AppTheme.colorTextSecond),
        )
      ],
    );
  }

  _tipText() {
    switch (tabId) {
      case 0:
        return RichText(
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              text: "评论了你的动态",
              style: AppTheme().textStyle(
                  fontSize: 14.sp, color: AppTheme.colorTextSecond),
              children: <TextSpan>[
                TextSpan(
                    style: AppTheme().textStyle(
                        fontSize: 14, color: AppTheme.colorTextWhite),
                    text: " “${model.content}”"),
              ],
            ));
      case 1:
        return RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              text: "提到了你",
              style: AppTheme().textStyle(
                  fontSize: 14.sp, color: AppTheme.colorTextSecond),
              children: <TextSpan>[
                TextSpan(
                    style: AppTheme().textStyle(
                        fontSize: 14, color: AppTheme.colorTextWhite),
                    text: " “${model.dynamicInfo?.content}”"),
              ],
            ));
      case 2:
        return RichText(
            text: TextSpan(
          text: "点赞了你的动态",
          style: AppTheme().textStyle(
              fontSize: 14.sp, color: AppTheme.colorTextSecond),
          children: <TextSpan>[
            TextSpan(
                style: AppTheme().textStyle(
                    fontSize: 14, color: AppTheme.colorTextWhite),
                text: ""),
          ],
        ));
    }
    return Container();
  }
}
