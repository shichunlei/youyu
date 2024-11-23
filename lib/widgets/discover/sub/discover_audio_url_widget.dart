import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/discover_item.dart';
import 'package:youyu/services/voice_service.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';

class DiscoverAudioUrlWidget extends StatefulWidget {
  const DiscoverAudioUrlWidget({super.key, required this.model});

  final DiscoverItem? model;

  @override
  State<DiscoverAudioUrlWidget> createState() => _DiscoverAudioUrlWidgetState();
}

class _DiscoverAudioUrlWidgetState extends State<DiscoverAudioUrlWidget>
    with VoiceAudioListener {
  @override
  void initState() {
    super.initState();
    widget.model?.curTime = (widget.model?.audioTime ?? 0.0).toInt();
    VoiceService().addAudioObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return AppRow(
      onTap: () {
        VoiceService()
            .playAudioUrl((widget.model?.id!).toString(), widget.model!.audio!);
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
          path: widget.model?.playerState == PlayerState.playing
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
              "${widget.model?.curTime}s",
              style: AppTheme().textStyle(
                  fontSize: 12.sp, color: AppTheme.colorTextPrimary),
            ),
          ),
        )
      ],
    );
  }

  ///VoiceAudioListener
  @override
  onPlayChangeState(PlayerState state, String? url, String? id, File? file) {
    if (widget.model?.audio == url && widget.model?.id.toString() == id) {
      if (mounted) {
        setState(() {
          widget.model?.playerState = state;
          if (widget.model?.playerState == PlayerState.stopped) {
            widget.model?.curTime = (widget.model?.audioTime ?? 0).toInt();
          }
        });
      }
    }
  }

  @override
  onPlayChangeTime(int p, String? url, String? id, File? file) {
    if (widget.model?.audio == url && widget.model?.id.toString() == id) {
      if (mounted) {
        setState(() {
          int tempTime = ((widget.model?.audioTime ?? 0).toInt() - p);
          if (tempTime < 0) {
            tempTime = 0;
          }
          widget.model?.curTime = tempTime;
        });
      }
    }
  }

  @override
  void dispose() {
    ///移除监听
    VoiceService().removeAudioObserver(this);

    ///判断停止&恢复数据
    if (widget.model?.playerState == PlayerState.playing) {
      widget.model?.playerState = PlayerState.stopped;
      widget.model?.curTime = (widget.model?.audioTime ?? 0.0).toInt();
      VoiceService().stopAudio();
    }
    super.dispose();
  }
}
