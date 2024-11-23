import 'dart:async';

import 'package:ai_progress/ai_progress.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/time_utils.dart';
import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/primary/discover/publish/discover_publish_logic.dart';
import 'package:youyu/services/permission_service.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/button/app_image_button.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';

class DiscoverAudioRecordWidget extends StatefulWidget {
  const DiscoverAudioRecordWidget({super.key, required this.logic});

  final DiscoverPublishLogic logic;

  @override
  State<DiscoverAudioRecordWidget> createState() =>
      _DiscoverAudioRecordWidgetState();
}

class _DiscoverAudioRecordWidgetState extends State<DiscoverAudioRecordWidget> {
  ///计时器
  Timer? _audioTimer;

  PermissionStatus permissionStatus = PermissionStatus.denied;

  @override
  Widget build(BuildContext context) {
    return AppColumn(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [_time(), _operationButton(), _bottomTexts()],
    );
  }

  ///时间
  _time() {
    return AppColumn(
      children: [
        Obx(
          () => Text(
            TimeUtils.countDownTimeBySeconds(widget.logic.seconds.value),
            style: AppTheme().textStyle(
                fontSize: 30.sp,
                color: AppTheme.colorTextWhite,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          '语音最长不超过30s',
          style: AppTheme().textStyle(
              fontSize: 12.sp, color: AppTheme.colorTextSecond),
        ),
      ],
    );
  }

  ///操作按钮
  _operationButton() {
    return Obx(() => AppRow(
          margin: EdgeInsets.only(top: 15.h),
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: widget.logic.audioState == DiscoverAudioRecordState.end
                  ? 1.0
                  : 0,
              child: AppImageButton(
                  path: AppResource().disAudioBack,
                  width: 48.w,
                  onClick: () {
                    widget.logic.seconds.value = 0;
                    widget.logic.segmentValue.value = 0.0;
                    widget.logic.setAudioState = DiscoverAudioRecordState.none;
                  }),
            ),
            SizedBox(
              width: 35.w,
            ),
            _centerButton(),
            SizedBox(
              width: 35.w,
            ),
            Opacity(
              opacity: widget.logic.audioState == DiscoverAudioRecordState.end
                  ? 1.0
                  : 0,
              child: AppImageButton(
                  path: AppResource().disAudioFinish,
                  width: 48.w,
                  onClick: () {
                    widget.logic.setAudioState =
                        DiscoverAudioRecordState.finish;
                  }),
            ),
          ],
        ));
  }

  ///中间按钮
  _centerButton() {
    ///长按录音
    return GestureDetector(
      onLongPressStart: (LongPressStartDetails details) async {
        if (widget.logic.audioState == DiscoverAudioRecordState.end) {
          ToastUtils.show("请点击重新录制");
          return;
        }
        widget.logic.setAudioState = DiscoverAudioRecordState.start;
        permissionStatus = await PermissionService().checkMicrophonePermission();
        if (permissionStatus == PermissionStatus.granted) {
          try {
            if (widget.logic.audioFile != null) {
              await widget.logic.deleteAudioFile();
            }
            _startTimer();
            RecordMp3.instance.start(widget.logic.audioFile?.path ?? "",
                (type) {
              // record fail callback
            });
          } catch (e) {
            _startTimer();
            RecordMp3.instance.start(widget.logic.audioFile?.path ?? "",
                (type) {
              // record fail callback
            });
          }
        }
      },
      onLongPressEnd: (LongPressEndDetails details) {
        _stopTimer();
      },
      onLongPressCancel: () {
        _stopTimer();
      },
      child: Container(
        alignment: Alignment.center,
        width: 105.w,
        height: 105.w,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AirCircularStateProgressIndicator(
              size: Size(105.w, 105.w),
              value: widget.logic.segmentValue.value * 100,
              //1~100
              pathColor: Colors.transparent,
              valueColor: AppTheme.colorMain,
              pathStrokeWidth: 2.w,
              valueStrokeWidth: 2.w,
              useCenter: false,
              filled: false,
            ),
            AppLocalImage(
                path: AppResource().disRecord, width: 94.w, height: 94.w)
          ],
        ),
      ),
    );
  }

  ///底部文案
  _bottomTexts() {
    return Obx(() => AppRow(
          margin: EdgeInsets.only(top: 22.h),
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: widget.logic.audioState == DiscoverAudioRecordState.end
                  ? 1.0
                  : 0,
              child: AppContainer(
                width: 48.w,
                child: Center(
                  child: Text(
                    '重录',
                    style: AppTheme().textStyle(
                        fontSize: 12.sp, color: AppTheme.colorTextDark),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 35.w,
            ),
            AppContainer(
              width: 105.w,
              child: Center(
                child: Text(
                  '点击开始录制',
                  style: AppTheme().textStyle(
                      fontSize: 12.sp, color: AppTheme.colorTextDark),
                ),
              ),
            ),
            SizedBox(
              width: 35.w,
            ),
            Opacity(
                opacity: widget.logic.audioState == DiscoverAudioRecordState.end
                    ? 1.0
                    : 0,
                child: AppContainer(
                  width: 48.w,
                  child: Center(
                    child: Text(
                      '完成',
                      style: AppTheme().textStyle(
                          fontSize: 12.sp,
                          color: AppTheme.colorTextDark),
                    ),
                  ),
                ))
          ],
        ));
  }

  _startTimer() {
    _audioTimer?.cancel();
    _audioTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (widget.logic.seconds.value >= widget.logic.maxTime) {
        _stopTimer();
        return;
      }
      widget.logic.seconds.value++;
      widget.logic.segmentValue.value =
          widget.logic.seconds.value / widget.logic.maxTime;
    });
  }

  _stopTimer() {
    if (_audioTimer != null) {
      _audioTimer?.cancel();
      _audioTimer = null;

      if (permissionStatus == PermissionStatus.granted) {
        if (widget.logic.seconds < 1) {
          ToastUtils.show("时间太短");
          RecordMp3.instance.stop();
          widget.logic.onDelAudio();
        } else {
          RecordMp3.instance.stop();
          widget.logic.setAudioState = DiscoverAudioRecordState.end;
        }
      }
    }
  }
}
