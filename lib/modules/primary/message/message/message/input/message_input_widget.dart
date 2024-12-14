import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/primary/message/message/input/message_input_content_widget.dart';
import 'package:youyu/modules/primary/message/message/message_detail_logic.dart';
import 'package:youyu/modules/primary/message/message/voice/message_voice_btn_widget.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///输入框
class MessageInputWidget extends StatelessWidget {
  const MessageInputWidget({super.key, required this.logic});

  final MessageDetailLogic logic;
  final Color inputColor = AppTheme.colorDarkBg;

  @override
  Widget build(BuildContext context) {
    return AppRow(
      height: logic.inputHeight,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //语音
        Obx(() => AppContainer(
              margin: EdgeInsets.symmetric(horizontal: 5.w),
              onTap: () {
                logic.onClickAudio();
              },
              width: 46.w,
              child: Center(
                child: AppLocalImage(
                  path: logic.state == MessageDetailInputState.audio
                      ? AppResource().kb
                      : AppResource().msgAudio,
                  width: 20.w,
                ),
              ),
            )),
        Obx(() => Expanded(
              child: AppStack(
                fit: StackFit.expand,
                radius: 99.w,
                color: const Color(0xFF000000),
                height: 40.h,
                children: [
                  logic.state == MessageDetailInputState.audio
                      ? MessageVoiceBtnWidget(
                          logic: logic,
                        )
                      : MessageInputContentWidget(logic: logic),
                ],
              ),
            )),
        SizedBox(
          width: 90.w,
          child: Center(
            child: AppColorButton(
              title: "发送",
              padding: EdgeInsets.zero,
              width: 60.w,
              fontSize: 14.sp,
              height: 30.h,
              titleColor: AppTheme.colorTextWhite,
              bgGradient: AppTheme().btnGradient,
              onClick: () {
                logic.onSendTextMessage();
              },
            ),
          ),
        ),
      ],
    );
  }
}
