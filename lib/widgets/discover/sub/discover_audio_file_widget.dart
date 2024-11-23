import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/services/voice_service.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';

class DiscoverAudioFileWidget extends StatefulWidget {
  const DiscoverAudioFileWidget(
      {super.key, required this.time, this.audioFile});

  final String time;
  final File? audioFile;

  @override
  State<DiscoverAudioFileWidget> createState() =>
      _DiscoverAudioFileWidgetState();
}

class _DiscoverAudioFileWidgetState extends State<DiscoverAudioFileWidget>
    with VoiceAudioListener {
  //播放时间
  int audioTime = 0;
  PlayerState playerState = PlayerState.stopped;

  @override
  void initState() {
    super.initState();
    audioTime = int.parse(widget.time);
    VoiceService().addAudioObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return AppRow(
      onTap: () {
        VoiceService().playAudioFile(widget.audioFile!);
      },
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      padding: EdgeInsets.symmetric(horizontal: 7.w),
      color: const Color(0xFFF7FFE8),
      height: 32.h,
      strokeWidth: 1,
      strokeColor: AppTheme.colorMain,
      radius: 99.h,
      children: [
        AppLocalImage(
          path: playerState == PlayerState.playing
              ? AppResource().disSmallPause
              : AppResource().disSmallPlay,
          width: 20.w,
        ),
        SizedBox(
          width: 8.w,
        ),
        AppLocalImage(
          path: AppResource().disSmallProgress,
          width: 56.w,
        ),
        SizedBox(
          width: 30.w,
          child: Center(
            child: Text(
              "${audioTime}s",
              style: AppTheme().textStyle(
                  fontSize: 12.sp, color: AppTheme.colorTextPrimary),
            ),
          ),
        )
      ],
    );
  }

  ///DynamicAudioListener
  @override
  onPlayChangeState(PlayerState state, String? url,String? id, File? file) {
    if (widget.audioFile?.path == file?.path) {
      setState(() {
        playerState = state;
        if (playerState == PlayerState.stopped) {
          audioTime = int.parse(widget.time);
        }
      });
    }
  }

  @override
  onPlayChangeTime(int p, String? url,String? id, File? file) {
    if (widget.audioFile?.path == file?.path) {
      setState(() {
        int tempTime = (int.parse(widget.time) - p);
        if (tempTime < 0) {
          tempTime = 0;
        }
        audioTime = tempTime;
      });
    }
  }

  @override
  void dispose() {
    VoiceService().removeAudioObserver(this);
    super.dispose();
  }
}
