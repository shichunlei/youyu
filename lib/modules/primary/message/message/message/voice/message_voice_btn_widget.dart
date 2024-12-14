import 'package:youyu/modules/primary/message/message/message/message_detail_logic.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/services/permission_service.dart';
import 'package:youyu/services/voice_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';

class MessageVoiceBtnWidget extends StatefulWidget {
  const MessageVoiceBtnWidget({super.key, required this.logic});

  final MessageDetailLogic logic;

  @override
  State<MessageVoiceBtnWidget> createState() => _MessageVoiceBtnWidgetState();
}

class _MessageVoiceBtnWidgetState extends State<MessageVoiceBtnWidget> {
  bool _isLongStart = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressMoveUpdate: (d) {
        if (d.globalPosition.dy < 680.w) {
          widget.logic.isAudioInputingCancle.value = true;
        } else {
          widget.logic.isAudioInputingCancle.value = false;
        }
      },
      onLongPressStart: (LongPressStartDetails details) async {
        _isLongStart = true;
        await VoiceService().stopAudio();
        PermissionStatus status =
            await PermissionService().checkMicrophonePermission();
        if (status != PermissionStatus.granted) {
          widget.logic.isAudioInputing.value = false;
        } else {
          if (_isLongStart) {
            widget.logic.isAudioInputing.value = true;
            await widget.logic.onAudioDel();
            RecordMp3.instance.start(widget.logic.audioFile?.path ?? "",
                (type) {
              // record fail callback
            });
            widget.logic.startTime = DateTime.now();
          }
        }
      },
      onLongPressEnd: (LongPressEndDetails d) async {
        _isLongStart = false;
        PermissionStatus status = await Permission.microphone.request();
        if (status != PermissionStatus.granted) {
          widget.logic.isAudioInputing.value = false;
          return;
        }
        _stopAudio(d);
      },
      onLongPressCancel: () async {
        _isLongStart = false;
        PermissionStatus status = await Permission.microphone.request();
        if (status != PermissionStatus.granted) {
          widget.logic.isAudioInputing.value = false;
          return;
        }
        _stopAudio(null);
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(99.h)),
            color: AppTheme.colorDarkLightBg),
        height: 40.h,
        child: Center(
          child: Text(
            '按住说话',
            style: AppTheme().textStyle(
                fontSize: 14.sp, color: AppTheme.colorTextSecond),
          ),
        ),
      ),
    );
  }

  _stopAudio(LongPressEndDetails? d) async {
    widget.logic.isAudioInputing.value = false;
    widget.logic.isAudioInputingCancle.value = false;
    if (d == null) return;
    int secs = DateTime.now().difference(widget.logic.startTime).inSeconds;
    if (d.globalPosition.dy < 680.w) {
    } else {
      if (secs > 0) {
        ///im发送
        RecordMp3.instance.stop();
        widget.logic.onSendAudioMessage(secs);
      } else {
        ToastUtils.show("录音时间太短");
      }
    }
  }
}
