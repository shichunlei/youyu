import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/room_list_item.dart';
import 'package:youyu/modules/primary/message/message/list/message_chat_list.dart';
import 'package:youyu/modules/primary/message/message/message_detail_logic.dart';
import 'package:youyu/modules/primary/message/message/view/message_detail_main_view.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/other/emoji/app_emoji_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/widgets/app/other/emoji/model/app_custom_emoji_item.dart';

import 'widget/live_message_detail_nav_bar.dart';

class LiveMessageDetailPage extends StatefulWidget {
  const LiveMessageDetailPage(
      {Key? key,
      required this.userId,
      required this.userName,
      required this.height,
      required this.onChangeLiveRoom,
      required this.isShowDirect})
      : super(key: key);

  ///用户系统id
  final int? userId;

  ///标题
  final String? userName;

  ///是否直接弹窗
  final bool isShowDirect;

  final double height;

  final Function(RoomListItem? item) onChangeLiveRoom;

  @override
  State<LiveMessageDetailPage> createState() => _LiveMessageDetailPageState();
}

class _LiveMessageDetailPageState extends State<LiveMessageDetailPage>
    with WidgetsBindingObserver {
  static const String _tag = 'live';

  late MessageDetailLogic logic = Get.find<MessageDetailLogic>(tag: _tag);

  bool isDispose = false;
  late AppEmojiWidget emojiWidget;
  late MessageChatListWidget chatListWidget;

  @override
  void initState() {
    super.initState();
    Get.put<MessageDetailLogic>(MessageDetailLogic(), tag: _tag);
    logic.userId = widget.userId;
    logic.pageTitle = widget.userName ?? "";
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
      tag: _tag,
      userId: logic.userId ?? 0,
    );

    logic.initData();
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
      tag: _tag,
      height: widget.height,
      navBar: LiveMessageDetailNavBar(
        key: logic.navKey,
        actionExtraWidth: 20.w,
        extraHeight: 10.h,
        hideBackArrow: widget.isShowDirect,
        backgroundColor: AppTheme.colorDarkBg,
        rightAction: logic.targetUserInfo.value != null
            ? Obx(() => logic.targetUserInfo.value?.isFocus == true
                ? const SizedBox.shrink()
                : AppContainer(
                    onTap: () {
                      UserController.to.onFocusUserOrCancel(
                          logic.targetUserInfo.value, onUpdate: () {
                        setState(() {});
                      });
                    },
                    radius: 99.h,
                    strokeWidth: 1.w,
                    width: 50.w,
                    height: 24.h,
                    strokeColor: const Color(0xFFFF3A3A),
                    child: Center(
                      child: Text(
                        '关注',
                        style: AppTheme().textStyle(
                            fontSize: 14.sp, color: const Color(0xFFFF3A3A)),
                      ),
                    ),
                  ))
            : null,
        onTapTitle: () {
          widget.onChangeLiveRoom(logic.targetUserInfo.value?.thisRoomInfo);
        },
      ),
      logic: logic,
      emojiWidget: emojiWidget,
      chatListWidget: chatListWidget,
      isShowTip: false,
    );
  }

  @override
  void dispose() {
    isDispose = true;
    Get.delete<MessageDetailLogic>(tag: _tag);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
