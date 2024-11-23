import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/conversation_controller.dart';
import 'package:youyu/modules/primary/message/index/conversation/widget/message_conversation_item.dart';
import 'package:youyu/modules/primary/message/index/conversation/widget/message_conversation_notify_item.dart';
import 'package:youyu/services/im/model/im_msg_type.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/list/app_list_separated_view.dart';
import 'package:youyu/widgets/app/other/app_segmentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'message_conversation_logic.dart';

class MessageConversationPage extends StatefulWidget {
  const MessageConversationPage({Key? key}) : super(key: key);

  @override
  State<MessageConversationPage> createState() =>
      _MessageConversationPageState();
}

class _MessageConversationPageState extends State<MessageConversationPage>
    with AutomaticKeepAliveClientMixin {
  final MessageConversationLogic logic = Get.put(MessageConversationLogic());

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppPage<MessageConversationLogic>(
      childBuilder: (s) {
        return AppContainer(
          radius: 6.w,
          margin: EdgeInsets.only(left: 14.w, right: 14.w, top: 14.h),
          color: AppTheme.colorDarkBg,
          child: SlidableAutoCloseBehavior(
            child: AppListSeparatedView(
              padding: EdgeInsets.only(bottom: ScreenUtils.safeBottomHeight),
              controller: logic.refreshController,
              itemCount: ConversationController.to.dataList.length + 2,
              isOpenLoadMore: false,
              isOpenRefresh: true,
              onRefresh: s.pullRefresh,
              separatorBuilder: (_, int index) {
                return AppSegmentation(
                  margin: EdgeInsets.only(left: 13.w, right: 9.w),
                  height: 1.h,
                  backgroundColor: AppTheme.colorLine,
                );
              },
              itemBuilder: (_, int index) {
                if (index == 0) {
                  return MessageConversationNotifyItem(
                      logic: logic, msgType: IMMsgType.officialSystem);
                } else if (index == 1) {
                  return MessageConversationNotifyItem(
                      logic: logic, msgType: IMMsgType.officialNotice);
                }
                V2TimConversation conversation =
                    ConversationController.to.dataList[index - 2];
                return MessageConversationItem(
                    key: UniqueKey(),
                    index: index - 2,
                    conversation: conversation,
                    onClickConversation: (V2TimConversation conversation) {
                      ConversationController.to
                          .onClickConversation(conversation);
                    });
              },
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
