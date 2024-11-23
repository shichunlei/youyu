import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/primary/message/message/message_detail_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

///语音弹窗
class MessageVoiceModalWidget extends StatelessWidget {
  const MessageVoiceModalWidget({super.key, required this.logic});

  final MessageDetailLogic logic;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          color: Colors.black.withOpacity(0.3),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 0.6.sw,
                  height: 0.2.sw,
                  decoration: BoxDecoration(
                    color: logic.isAudioInputingCancle.value
                        ? AppTheme.colorRed
                        : null,
                    gradient: logic.isAudioInputingCancle.value
                        ? null
                        : AppTheme().btnGradient,
                    borderRadius: BorderRadius.all(Radius.circular(5.w)),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 50.w,
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.white,
                        size: 50.w,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.w,
                ),
                Text(
                  logic.isAudioInputingCancle.value ? '取消发送' : '手指上滑,取消发送',
                  style: TextStyle(
                    color: logic.isAudioInputingCancle.value
                        ? AppTheme.colorRed
                        : Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
