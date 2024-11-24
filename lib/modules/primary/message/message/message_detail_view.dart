import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/modules/primary/message/message/list/message_chat_list.dart';
import 'package:youyu/modules/primary/message/message/nav/message_detail_nav_bar.dart';
import 'package:youyu/modules/primary/message/message/view/message_detail_main_view.dart';
import 'package:youyu/router/router.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/other/emoji/app_emoji_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/widgets/app/other/emoji/model/app_custom_emoji_item.dart';
import 'message_detail_logic.dart';

class MessageDetailPage extends StatefulWidget {
  const MessageDetailPage({Key? key}) : super(key: key);

  @override
  State<MessageDetailPage> createState() => _MessageDetailPageState();
}

class _MessageDetailPageState extends State<MessageDetailPage>
    with WidgetsBindingObserver {
  MessageDetailLogic logic = Get.find<MessageDetailLogic>();

  bool isDispose = false;
  late AppEmojiWidget emojiWidget;
  late MessageChatListWidget chatListWidget;

  @override
  void initState() {
    super.initState();
    //初始化
    WidgetsBinding.instance.addObserver(this);

    emojiWidget = AppEmojiWidget(
      isShowCustom: true,
      onBackspacePressed: () {},
      editingController: logic.chatTextEditingController,
      onClickGif: (AppCustomEmojiItem item) {
        //TODO:test
      },
    );

    chatListWidget = MessageChatListWidget(
      userId: logic.userId ?? 0,
    );
  }

  // 监听
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !isDispose) {
        double bottom = MediaQuery.of(context).viewInsets.bottom;
        logic.onKeyBoardChange(bottom);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    logic.context ??= context;
    return MessageDetailMainView(
      navBar: MessageDetailNavBar(
        key: logic.navKey,
        title: logic.pageTitle,
        rightAction: AppContainer(
          onTap: () {
            Get.toNamed(AppRouter().messagePages.messageSetRoute.name,
                arguments: {
                  "userId": logic.userId,
                  "targetUserInfo": logic.targetUserInfo.value
                });
          },
          width: 40.w,
          height: 40.h,
          child: Align(
            alignment: Alignment.centerRight,
            child: AppLocalImage(
              height: 18.h,
              width: 18.w,
              path: AppResource().more,
            ),
          ),
        ),
      ),
      logic: logic,
      emojiWidget: emojiWidget,
      chatListWidget: chatListWidget,
      isShowTip: true,
    );
  }

  @override
  void dispose() {
    isDispose = true;
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
