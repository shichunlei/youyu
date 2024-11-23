import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/app/app_default.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/conversation_controller.dart';
import 'package:youyu/modules/primary/message/index/conversation/widget/message_conversation_item.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/list/app_list_separated_view.dart';
import 'package:youyu/widgets/app/other/app_segmentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'live_conversation_logic.dart';
import 'widget/live_conversation_nav_bar.dart';

class LiveConversationPage extends StatelessWidget {
  LiveConversationPage(
      {Key? key, required this.onClickConversation, this.height})
      : super(key: key);
  final double? height;

  final logic = Get.put(LiveConversationLogic());
  final Function(V2TimConversation conversation) onClickConversation;

  @override
  Widget build(BuildContext context) {
    return AppPage<LiveConversationLogic>(
      bodyHeight: height,
      isUseScaffold: false,
      backgroundColor: Colors.transparent,
      childBuilder: (s) {
        return AppColumn(
          topRightRadius: 20.w,
          topLeftRadius: 20.w,
          color: AppTheme.colorDarkBg,
          children: [
            LiveConversationNavBar(
              height: ScreenUtils.navbarHeight + 10.h,
              topRadius: 20.w,
              title: "消息",
              backgroundColor: AppTheme.colorDarkBg,
              hideBackArrow: true,
              rightAction: AppContainer(
                onTap: () {
                  ConversationController.to.onClickClearUnRead();
                },
                width: 40.w,
                height: 40.h,
                child: Align(
                  alignment: Alignment.center,
                  child: AppLocalImage(
                    height: 18.h,
                    width: 18.w,
                    imageColor: AppTheme.colorMain,
                    path: AppResource().msgUnreadClear,
                  ),
                ),
              ),
            ),
            Expanded(
                child: SlidableAutoCloseBehavior(
              child: AppListSeparatedView(
                padding: EdgeInsets.only(bottom: ScreenUtils.safeBottomHeight),
                controller: logic.refreshController,
                itemCount: ConversationController.to.dataList.length,
                isOpenLoadMore: false,
                isOpenRefresh: true,
                isNoData: logic.isNoData,
                defaultConfig: AppDefaultConfig(
                    title: "暂无消息",
                    image: AppResource().empty),
                onRefresh: s.pullRefresh,
                separatorBuilder: (_, int index) {
                  return AppSegmentation(
                    margin: EdgeInsets.only(left: 13.w, right: 9.w),
                    height: 1.h,
                    backgroundColor: AppTheme.colorLine,
                  );
                },
                itemBuilder: (_, int index) {
                  V2TimConversation conversation =
                      ConversationController.to.dataList[index];
                  return MessageConversationItem(
                    key: UniqueKey(),
                    index: index - 2,
                    conversation: conversation,
                    onClickConversation: onClickConversation,
                  );
                },
              ),
            ))
          ],
        );
      },
    );
  }
}
