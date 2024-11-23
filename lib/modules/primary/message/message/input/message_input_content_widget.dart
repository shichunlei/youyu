import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/primary/message/message/message_detail_logic.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/input/app_normal_input.dart';
import 'package:flutter/material.dart';

class MessageInputContentWidget extends StatelessWidget {
  const MessageInputContentWidget({super.key, required this.logic});

  final MessageDetailLogic logic;

  @override
  Widget build(BuildContext context) {
    return AppStack(
      fit: StackFit.expand,
      children: [
        AppNormalInput(
          radius: 99.w,
          paddingLeft: 15.w,
          paddingRight: 15.w,
          focusNode: logic.focusNode,
          controller: logic.chatTextEditingController,
          textColor: AppTheme.colorTextWhite,
          textAlign: TextAlign.left,
          height: 40.h,
          textInputAction: TextInputAction.send,
          onSubmitted: (text) {
            logic.onSendTextMessage();
          },
          placeHolder: "请输入聊天内容...",
          backgroundColor: const Color(0xFF000000),
        ),
        if (logic.state != MessageDetailInputState.text)
          AppContainer(
            color: Colors.transparent,
            onTap: () {
              logic.onClickShowKb();
            },
          )
      ],
    );
  }
}
