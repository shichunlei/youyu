import 'dart:io';
import 'package:async/async.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/primary/message/message/list/widget/base/im_msg_base_widget.dart';
import 'package:youyu/services/voice_service.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_online_url.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';

///语音item
class IMMsgAudioWidget<IMMsgVoiceModel> extends IMMsgBaseWidget {
  const IMMsgAudioWidget(
      {super.key,
      required super.message,
      required super.index,
      required super.logic});

  @override
  _IMMsgAudioWidgetState<IMMsgAudioWidget> createState() =>
      _IMMsgAudioWidgetState();
}

class _IMMsgAudioWidgetState<T extends IMMsgAudioWidget>
    extends IMMsgBaseWidgetState<IMMsgAudioWidget> with VoiceAudioListener {
  //TODO:get/set
  int get curTime {
    if (widget.message.localCustomData?.isNotEmpty == true) {
      String time = widget.message.localCustomData?.split(",").first ?? "0";
      return int.parse(time);
    }
    return widget.message.soundElem?.duration ?? 0;
  }

  set setCurTime(int value) {
    if (widget.message.localCustomData?.isNotEmpty == true) {
      String state = widget.message.localCustomData?.split(",")[1] ??
          "PlayerState.stopped";
      widget.message.localCustomData = "$value,$state";
    } else {
      widget.message.localCustomData = "$value,PlayerState.stopped";
    }
  }

  PlayerState get playerState {
    if (widget.message.localCustomData?.isNotEmpty == true) {
      String state = widget.message.localCustomData?.split(",")[1] ??
          "PlayerState.stopped";
      if (state.contains("stopped")) {
        return PlayerState.stopped;
      } else if (state.contains("playing")) {
        return PlayerState.playing;
      } else if (state.contains("paused")) {
        return PlayerState.paused;
      } else if (state.contains("completed")) {
        return PlayerState.completed;
      } else if (state.contains("disposed")) {
        return PlayerState.disposed;
      }
      return PlayerState.stopped;
    }
    return PlayerState.stopped;
  }

  set setPlayerState(PlayerState value) {
    if (widget.message.localCustomData?.isNotEmpty == true) {
      String time = widget.message.localCustomData?.split(",").first ?? "0";
      widget.message.localCustomData = "$time,${value.toString()}";
    } else {
      widget.message.localCustomData = "0,${value.toString()}";
    }
  }

  ///cancel future
  CancelableOperation? _myCancelableFuture;

  @override
  void initState() {
    super.initState();
    setCurTime = widget.message.soundElem?.duration ?? 0;
    VoiceService().addAudioObserver(this);
  }

  @override
  senderContent() {
    return _audioWidget();
  }

  @override
  receiveContent() {
    return _audioWidget();
  }

  _audioWidget() {
    return AppRow(
      onTap: () {
        _playAudio();
      },
      margin: EdgeInsets.only(top: 8.h),
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
              "${curTime}s",
              style: AppTheme().textStyle(
                  fontSize: 12.sp, color: AppTheme.colorTextPrimary),
            ),
          ),
        )
      ],
    );
  }

  _playAudio() async {
    if (widget.message.soundElem?.localUrl?.isNotEmpty == true) {
      VoiceService().playAudioUrl((widget.message.msgID!).toString(),
          widget.message.soundElem?.localUrl ?? "");
      return;
    } else {
      // 获取多媒体消息URL
      _myCancelableFuture = CancelableOperation.fromFuture(
        _fetchUrl(),
        onCancel: () => 'Future has been canceld',
      );

      V2TimValueCallback<V2TimMessageOnlineUrl> getMessageOnlineUrlRes =
          await _myCancelableFuture?.value;
      if (getMessageOnlineUrlRes.code == 0) {
        // 获取成功
        widget.message.soundElem?.localUrl =
            getMessageOnlineUrlRes.data?.soundElem?.url;
        if (widget.message.soundElem?.localUrl?.isNotEmpty == true) {
          VoiceService().playAudioUrl((widget.message.msgID!).toString(),
              widget.message.soundElem?.localUrl ?? "");
          return;
        }
      }
    }

    ///音频已损坏
    if (widget.message.soundElem?.localUrl == null ||
        widget.message.soundElem?.localUrl?.isNotEmpty == false) {
      setPlayerState = PlayerState.stopped;
      setCurTime = (widget.message.soundElem?.duration ?? 0.0).toInt();
      VoiceService().stopAudio();
      ToastUtils.show("音频已损坏");
    }
  }

  _fetchUrl() async {
    V2TimValueCallback<V2TimMessageOnlineUrl> getMessageOnlineUrlRes =
        await TencentImSDKPlugin.v2TIMManager
            .getMessageManager()
            .getMessageOnlineUrl(
              msgID: widget.message.msgID ?? "", // 消息id
            );
    return getMessageOnlineUrlRes;
  }

  ///VoiceAudioListener
  @override
  onPlayChangeState(PlayerState state, String? url, String? id, File? file) {
    if (widget.message.soundElem?.localUrl == url &&
        widget.message.msgID.toString() == id) {
      _playChangeState(state, url, id, file);
    }
  }

  _playChangeState(PlayerState state, String? url, String? id, File? file) {
    if (mounted) {
      setState(() {
        setPlayerState = state;
        if (playerState == PlayerState.stopped) {
          setCurTime = (widget.message.soundElem?.duration ?? 0).toInt();
        }
      });
    }
  }

  @override
  onPlayChangeTime(int p, String? url, String? id, File? file) {
    if (widget.message.soundElem?.localUrl == url &&
        widget.message.msgID.toString() == id) {
      _playChangeTime(p, url, id, file);
    }
  }

  _playChangeTime(int p, String? url, String? id, File? file) {
    if (mounted) {
      setState(() {
        int tempTime = ((widget.message.soundElem?.duration ?? 0).toInt() - p);
        if (tempTime < 0) {
          tempTime = 0;
        }
        setCurTime = tempTime;
      });
    }
  }

  @override
  void dispose() {
    ///移除监听
    VoiceService().removeAudioObserver(this);
    _myCancelableFuture?.cancel();
    setCurTime = (widget.message.soundElem?.duration ?? 0.0).toInt();

    ///判断停止&恢复数据
    if (playerState == PlayerState.playing) {
      setPlayerState = PlayerState.stopped;
      VoiceService().stopAudio();
    }

    super.dispose();
  }
}
