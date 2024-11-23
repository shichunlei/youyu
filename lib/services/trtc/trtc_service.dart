import 'dart:async';

import 'package:youyu/modules/live/common/model/mic_seat_state.dart';
import 'package:youyu/utils/log_utils.dart';
import 'package:youyu/utils/platform_utils.dart';
import 'package:youyu/utils/toast_utils.dart';
import 'package:youyu/config/config.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/room_detail_info.dart';
import 'package:youyu/modules/live/common/message/live_message.dart';
import 'package:youyu/services/im/im_service.dart';
import 'package:youyu/services/socket/socket_msg_type.dart';
import 'package:youyu/services/socket/socket_service.dart';
import 'package:youyu/utils/format_utils.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import 'package:tencent_trtc_cloud/trtc_cloud.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_def.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_listener.dart';
import 'package:tencent_trtc_cloud/tx_audio_effect_manager.dart';
import 'package:tencent_trtc_cloud/tx_device_manager.dart';
import 'model/user_volume.dart';

mixin UserVoiceVolumeListener {
  onUserVoiceVolume(List<UserVolume> list);
}

///音视频服务
class TRTCService extends AppBaseController {
  static const String _tag = "TRTCService";

  static TRTCService? _instance;

  factory TRTCService() => _instance ??= TRTCService._();

  TRTCService._();

  //音器
  late TRTCCloud trtcCloud;

  //音效
  late TXAudioEffectManager txAudioManager;

  //设备管理
  late TXDeviceManager deviceManager;

  //音量监听
  UserVoiceVolumeListener? volumeListener;

  //当前直播间信息
  Rx<RoomDetailInfo?> currentRoomInfo = Rx(null);

  //当前上的麦位信息
  MicSeatState? currentSeatState;

  //公屏消息列表
  List<LiveMessageModel> allScreenList = [];
  List<LiveMessageModel> chatScreenList = [];
  List<LiveMessageModel> giftScreenList = [];

  //是否上麦
  var isUpMic = false.obs;

  //是否禁麦(自己禁止自己的声音)
  var isMuted = false.obs;

  //是否静音(关闭直播间所有人的声音)
  var isCloseVolume = false.obs;

  ///前台服务定时
  Timer? _fServiceTimer;

  @override
  void onInit() async {
    super.onInit();
    trtcCloud = (await TRTCCloud.sharedInstance())!;
    txAudioManager = trtcCloud.getAudioEffectManager();
    deviceManager = trtcCloud.getDeviceManager();
  }

  ///进入音视频房间
  Future joinTRTCRoom({
    required int roomId,
    required String groupId,
    required Rx<RoomDetailInfo?> roomDetailInfo,

    /// TRTCCloudDef.TRTCRoleAnchor 主播
    /// TRTCCloudDef.TRTCRoleAudience 听众
    int role = TRTCCloudDef.TRTCRoleAudience,
  }) async {
    currentRoomInfo = roomDetailInfo;
    int startTime = DateTime.now().millisecondsSinceEpoch;
    await Future.wait([
      (() async {
        await trtcCloud.enterRoom(
          TRTCParams(
            sdkAppId: AppConfig.imAppId,
            userId: FormatUtil.getImUserId(UserController.to.id.toString()),
            userSig: UserController.to.imUserSig,
            role: role,
            roomId: roomId,
          ),
          // TRTCCloudDef.TRTC_APP_SCENE_VOICE_CHATROOM,
          TRTCCloudDef.TRTC_APP_SCENE_VOICE_CHATROOM,
        );
      })(),
      (() async {
        await IMService().joinRoom(groupId);
      })()
    ]);
    int endTime = DateTime.now().millisecondsSinceEpoch;
    int totalTime = endTime - startTime;
    LogUtils.onInfo('总共耗时${totalTime}ms', tag: _tag);

    trtcCloud.enableAudioVolumeEvaluation(500);
    deviceManager.setAudioRoute(TRTCCloudDef.TRTC_AUDIO_ROUTE_SPEAKER);
    trtcCloud.registerListener(_onTRTCListener);
    _startService();
  }

  _startService() async {
    if (PlatformUtils.isAndroid) {
      if (await FlutterForegroundTask.isRunningService) {
        return;
      }
      _fServiceTimer?.cancel();
      _fServiceTimer = Timer(const Duration(milliseconds: 800), () {
        FlutterForegroundTask.startService(
            notificationTitle: AppConfig.appName,
            notificationText: "正在${currentRoomInfo.value?.name ?? ""}房间");
      });
    }
  }

  // 离开房间
  leaveRoom() async {
    await trtcCloud.stopLocalAudio();
    await trtcCloud.exitRoom();
    await IMService().leaveRoom(currentRoomInfo.value?.groupId ?? "",
        FormatUtil.getImUserId(UserController.to.id.toString()));
    // if (TRTCService().isUpMic.value && currentSeatState != null) {
    //   await sendOnWheatChange(position: currentSeatState!.position);
    // }
    SocketService().sendMessage(
        '{"type":"${SocketMessageType.outRoom}", "room_id": ${currentRoomInfo.value?.id}}');
    isUpMic.value = false;
    isMuted.value = false;
    isCloseVolume.value = false;
    trtcCloud.unRegisterListener(_onTRTCListener);
    currentRoomInfo.value = null;
    currentSeatState = null;
    allScreenList.clear();
    chatScreenList.clear();
    giftScreenList.clear();
    _stopService();
  }

  _stopService() {
    if (PlatformUtils.isAndroid) {
      //关闭前台服务
      _fServiceTimer?.cancel();
      FlutterForegroundTask.stopService();
    }
  }

  /// 下麦
  downMic() {
    trtcCloud.switchRole(TRTCCloudDef.TRTCRoleAudience);
    trtcCloud.stopLocalAudio();
    isUpMic.value = false;
    currentSeatState = null;
  }

  /// 上麦
  upMic({bool needChangeMuted = false, MicSeatState? mySeat}) async {
    if (isUpMic.value) return;
    trtcCloud.switchRole(TRTCCloudDef.TRTCRoleAnchor);
    isUpMic.value = true;
    if (needChangeMuted) {
      await trtcCloud.setAudioCaptureVolume(0);
      isMuted.value = false;
    }
    try {
      await trtcCloud.startLocalAudio(TRTCCloudDef.TRTC_AUDIO_QUALITY_MUSIC);
      currentSeatState = mySeat;
    } catch (e) {
      logger.e(e);
    }
  }

  /// 开麦
  openMic() async {
    await trtcCloud.setAudioCaptureVolume(100);
    LogUtils.onInfo('开启了声音', tag: _tag);
    isMuted.value = true;
  }

  /// 闭麦
  closeMic() async {
    await trtcCloud.setAudioCaptureVolume(0);
    LogUtils.onInfo('关闭了声音', tag: _tag);
    isMuted.value = false;
  }

  /// 静音
  closeVolume() {
    trtcCloud.muteAllRemoteAudio(true);
    isCloseVolume.value = true;
  }

  /// 取消静音
  openVolume() {
    trtcCloud.muteAllRemoteAudio(false);
    isCloseVolume.value = false;
  }

  // 事件监听
  _onTRTCListener(type, params) async {
    switch (type) {
      case TRTCCloudListener.onError:
        LogUtils.onInfo('onError', tag: _tag);
        LogUtils.onInfo(params, tag: _tag);
        break;
      case TRTCCloudListener.onWarning:
        break;
      case TRTCCloudListener.onEnterRoom:
        LogUtils.onInfo('onEnterRoom', tag: _tag);
        LogUtils.onInfo(params, tag: _tag);
        break;
      case TRTCCloudListener.onExitRoom:
        LogUtils.onInfo('onExitRoom', tag: _tag);
        LogUtils.onInfo(params, tag: _tag);
        break;
      case TRTCCloudListener.onSwitchRole:
        LogUtils.onInfo('onSwitchRole', tag: _tag);
        LogUtils.onInfo(params, tag: _tag);
        break;
      case TRTCCloudListener.onRemoteUserEnterRoom:
        LogUtils.onInfo('onRemoteUserEnterRoom', tag: _tag);
        LogUtils.onInfo(params, tag: _tag);
        break;
      case TRTCCloudListener.onRemoteUserLeaveRoom:
        LogUtils.onInfo('onRemoteUserLeaveRoom', tag: _tag);
        LogUtils.onInfo(params, tag: _tag);
        break;
      case TRTCCloudListener.onConnectOtherRoom:
        break;
      case TRTCCloudListener.onDisConnectOtherRoom:
        break;
      case TRTCCloudListener.onSwitchRoom:
        break;
      case TRTCCloudListener.onUserVideoAvailable:
        // onUserVideoAvailable(params["userId"], params['available']);
        break;
      case TRTCCloudListener.onUserSubStreamAvailable:
        break;
      case TRTCCloudListener.onUserAudioAvailable:
        break;
      case TRTCCloudListener.onFirstVideoFrame:
        break;
      case TRTCCloudListener.onFirstAudioFrame:
        break;
      case TRTCCloudListener.onSendFirstLocalVideoFrame:
        break;
      case TRTCCloudListener.onSendFirstLocalAudioFrame:
        break;
      case TRTCCloudListener.onNetworkQuality:
        // logger.d('onNetworkQuality');
        // logger.d(params);
        break;
      case TRTCCloudListener.onStatistics:
        break;
      case TRTCCloudListener.onConnectionLost:
        LogUtils.onInfo('断开了链接', tag: _tag);
        break;
      case TRTCCloudListener.onTryToReconnect:
        LogUtils.onInfo('尝试重新链接', tag: _tag);
        break;
      case TRTCCloudListener.onConnectionRecovery:
        break;
      case TRTCCloudListener.onSpeedTest:
        LogUtils.onInfo('onSpeedTest', tag: _tag);
        LogUtils.onInfo(params, tag: _tag);
        break;
      case TRTCCloudListener.onCameraDidReady:
        break;
      case TRTCCloudListener.onMicDidReady:
        LogUtils.onInfo('onMicDidReady', tag: _tag);
        LogUtils.onInfo(params, tag: _tag);
        break;
      case TRTCCloudListener.onUserVoiceVolume:
        {
          // logger.d('onUserVoiceVolume');
          // logger.d(params['userVolumes']);
          if (volumeListener != null) {
            volumeListener?.onUserVoiceVolume(params['userVolumes']
                .map<UserVolume>((v) => UserVolume.fromJson(v))
                .where((v) => v.volume != 0)
                .toList());
          }
        }
        break;
      case TRTCCloudListener.onRecvCustomCmdMsg:
        LogUtils.onInfo('onMicDidReady', tag: _tag);
        LogUtils.onInfo(params, tag: _tag);
        break;
      case TRTCCloudListener.onMissCustomCmdMsg:
        break;
    }
  }

  ///ws发送
  //  0：空位
  //  1：上麦
  //  2：锁麦
  sendOnWheatChange(
      {required int position, int state = 0, int mute = 0, int userId = -1}) {
    bool isSendSuc = SocketService().sendMessage(
        '{"type":"${SocketMessageType.actionWheat}","room_id":${currentRoomInfo.value?.id},"position": $position, "state": $state, "mute": $mute, "user_id": $userId}');
    if (!isSendSuc) {
      ToastUtils.show("操作失败，请重试");
    }
  }

  //禁麦/解麦
  sendOnMuteChange(
      {required int position, int state = 0, int mute = 0, int userId = -1}) {
    bool isSendSuc = SocketService().sendMessage(
        '{"type":"${SocketMessageType.position}","room_id":${currentRoomInfo.value?.id},"position": $position, "state": $state, "mute": $mute, "user_id": $userId}');
    if (!isSendSuc) {
      ToastUtils.show("操作失败，请重试");
    }
  }
}
