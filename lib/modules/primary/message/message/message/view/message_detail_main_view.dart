import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/primary/message/message/input/message_input_bottom_widget.dart';
import 'package:youyu/modules/primary/message/message/input/message_input_widget.dart';
import 'package:youyu/modules/primary/message/message/list/message_chat_list.dart';
import 'package:youyu/modules/primary/message/message/message_detail_logic.dart';
import 'package:youyu/modules/primary/message/message/tip/message_detail_tip_widget.dart';
import 'package:youyu/modules/primary/message/message/voice/message_voice_modal_widget.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/other/emoji/app_emoji_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageDetailMainView extends StatelessWidget {
  const MessageDetailMainView(
      {super.key,
      required this.logic,
      required this.emojiWidget,
      required this.chatListWidget,
      required this.navBar,
      required this.isShowTip,
      this.tag,
      this.height});

  final MessageDetailLogic logic;

  //是否显示顶部直播中tip
  final bool isShowTip;

  //页面tag
  final String? tag;

  //页面高度
  final double? height;

  ///view
  //nav bar
  final PreferredSizeWidget navBar;

  //emoji
  final AppEmojiWidget emojiWidget;

  //chat list
  final MessageChatListWidget chatListWidget;

  @override
  Widget build(BuildContext context) {
    return AppStack(
      height: height,
      children: [
        AppPage<MessageDetailLogic>(
          bodyHeight: height,
          backgroundColor: Colors.transparent,
          tag: tag,
          resizeToAvoidBottomInset: false,
          appBar: navBar,
          childBuilder: (s) {
            return AppStack(
              color: AppTheme.colorBg,
              children: [
                ///内容
                Positioned(
                    left: 0,
                    top: 0,
                    right: 0,
                    bottom: logic.inputHeight + logic.bottomMoreHeight,
                    child: _content()),

                ///输入&更多
                Positioned(
                    left: 0, bottom: 0, right: 0, child: _bottomInputAndMore()),

                ///表情
                Positioned(left: 0, bottom: 0, right: 0, child: _bottomEmoji())
              ],
            );
          },
        ),

        ///语音
        Obx(() => logic.isAudioInputing.value
            ? MessageVoiceModalWidget(logic: logic)
            : const SizedBox.shrink())
      ],
    );
  }

  ///内容
  _content() {
    return AppStack(
      fit: StackFit.expand,
      width: double.infinity,
      height: double.infinity,
      children: [
        //聊天内容
        Column(
          children: [
            if (isShowTip)
              Obx(() => logic.titleState.value ==
                          MessageDetailTitleState.live &&
                      !logic.isCloseLive.value
                  ? Container(
                      margin:
                          EdgeInsets.only(left: 14.w, right: 14.w, top: 10.h),
                      height: 60.h,
                      child: MessageDetailTipWidget(
                        name: logic.targetUserInfo.value?.thisRoomInfo?.name ?? "",
                        onClickToLive: logic.onClickToLive,
                        onClickClose: logic.onClickCloseLive,
                      ),
                    )
                  : const SizedBox.shrink()),
            Expanded(child: chatListWidget)
          ],
        ),
        Obx(() => (logic.state != MessageDetailInputState.none &&
                logic.state != MessageDetailInputState.audio)
            ? AppContainer(
                color: Colors.transparent,
                onTap: () {
                  logic.onClickMaskNone();
                },
              )
            : const SizedBox.shrink())
      ],
    );
  }

  ///底部输入&更多
  _bottomInputAndMore() {
    return AppColumn(
      color: AppTheme.colorDarkBg,
      onTap: () {
        //...
      },
      children: [
        ///聊天输入框
        MessageInputWidget(logic: logic),

        ///底部更多
        MessageInputBottomWidget(
          logic: logic,
        ),

        ///占位
        Obx(() => AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: Container(
              color: AppTheme.colorDarkBg,
              height: logic.inputBottomHeight.value,
            )))
      ],
    );
  }

  ///底部表情
  _bottomEmoji() {
    return Obx(() => AppColumn(
          color: AppTheme.colorDarkBg,
          children: [
            AnimatedSize(
              duration: logic.beforeState == MessageDetailInputState.text
                  ? const Duration(milliseconds: 10)
                  : const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: SizedBox(
                width: double.infinity,
                height: (logic.state == MessageDetailInputState.emoji)
                    ? logic.emojiHeight
                    : 0,
                child: emojiWidget,
              ),
            ),
            if (logic.state == MessageDetailInputState.emoji)
              AnimatedSize(
                duration: logic.beforeState == MessageDetailInputState.text
                    ? const Duration(milliseconds: 10)
                    : const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: SizedBox(
                  width: double.infinity,
                  height: (logic.state == MessageDetailInputState.emoji)
                      ? ScreenUtils.safeBottomHeight
                      : 0,
                ),
              ),
          ],
        ));
  }
}
