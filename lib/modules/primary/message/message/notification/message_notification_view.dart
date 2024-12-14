import 'package:youyu/modules/primary/message/message/message/list/widget/base/im_msg_base_widget.dart';
import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/services/im/model/im_msg_type.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/list/app_list_separated_view.dart';
import 'package:youyu/widgets/app/other/app_segmentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'message_notification_logic.dart';

class MessageNotificationPage extends StatelessWidget {
  MessageNotificationPage({Key? key}) : super(key: key);

  final logic = Get.find<MessageNotificationLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<MessageNotificationLogic>(
      appBar: AppTopBar(
        key: logic.navKey,
        title: logic.msgType == IMMsgType.officialSystem ? "系统消息" : "官方公告",
      ),
      childBuilder: (s) {
        return AppListSeparatedView(
          padding:
              EdgeInsets.only(bottom: ScreenUtils.safeBottomHeight, top: 10.h),
          controller: logic.refreshController,
          itemCount: logic.dataList.length,
          isOpenLoadMore: false,
          isOpenRefresh: false,
          isNoData: logic.isNoData,
          separatorBuilder: (_, int index) {
            return AppSegmentation(
              margin: EdgeInsets.only(left: 13.w, right: 9.w),
              height: 15.h,
              backgroundColor: Colors.transparent,
            );
          },
          itemBuilder: (_, int index) {
            return _item(logic.dataList[index]);
          },
        );
      },
    );
  }

  _item(text) {
    return AppRow(
      crossAxisAlignment: CrossAxisAlignment.start,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      width: double.infinity,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppLocalImage(
          path: logic.msgType == IMMsgType.officialNotice
              ? AppResource().msgOfficialNotice
              : AppResource().msgOfficialSystem,
          width: 48.w,
          height: 48.w,
        ),
        SizedBox(
          width: 8.w,
        ),
        AppRow(
          constraints: BoxConstraints(
            minHeight: 32.h,
            maxWidth: IMMsgBaseWidget.itemMaxWidth,
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
          color: AppTheme.colorTextWhite,
          topLeftRadius: 6.w,
          topRightRadius: 6.w,
          bottomRightRadius: 6.w,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
                child: Text(
              text,
              maxLines: 10000,
              style: AppTheme().textStyle(
                  fontSize: 14.sp,
                  color: AppTheme.colorTextPrimary,
                  fontWeight: FontWeight.w500),
            ))
          ],
        )
      ],
    );
  }
}
