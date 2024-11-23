import 'package:youyu/modules/live/common/model/mic_seat_state.dart';
import 'package:youyu/modules/live/index/live_index_logic.dart';
import 'package:youyu/utils/log_utils.dart';
import 'package:youyu/widgets/gift/model/common_gift_pop_model.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/models/sync_room_seat.dart';
import 'package:youyu/services/trtc/model/user_volume.dart';
import 'package:youyu/services/trtc/trtc_service.dart';
import 'package:youyu/utils/format_utils.dart';
import 'package:get/get.dart';

///麦位
mixin LiveBaseSeatBsListener {
  //在麦用户列表
  List<GiftUserPositionInfo> onSeatMicUsers();

  //麦位信息
  RxList<MicSeatState> onSeatMics();

  //说话的用户ID列表
  RxList<int> onSeatTalkingUsers();

  //上麦
  void onSeatUnMic();

  //下麦
  Future<void> onSeatDownMic();

  //麦位信息同步
  void onSeatSyncMics(List<SyncRoomSeat> syncRoomSeat);

  //是否在麦上
  bool onSeatCheckIsOnMic(int userId);

  //是否禁麦
  bool onSeatCheckIsDisableMic(int userId);

  //声音回调
  void onSeatVolumeChanged(List<UserVolume> userVolumes);
}

class LiveBaseSeatBs with LiveBaseSeatBsListener {
  ///麦位
  RxList<MicSeatState> mics = <MicSeatState>[
    MicSeatState(
        state: 0, mute: 0, position: 0, charm: 0, heart: 0, wishGiftId: 0),
    MicSeatState(
        state: 0, mute: 0, position: 1, charm: 0, heart: 0, wishGiftId: 0),
    MicSeatState(
        state: 0, mute: 0, position: 2, charm: 0, heart: 0, wishGiftId: 0),
    MicSeatState(
        state: 0, mute: 0, position: 3, charm: 0, heart: 0, wishGiftId: 0),
    MicSeatState(
        state: 0, mute: 0, position: 4, charm: 0, heart: 0, wishGiftId: 0),
    MicSeatState(
        state: 0, mute: 0, position: 5, charm: 0, heart: 0, wishGiftId: 0),
    MicSeatState(
        state: 0, mute: 0, position: 6, charm: 0, heart: 0, wishGiftId: 0),
    MicSeatState(
        state: 0, mute: 0, position: 7, charm: 0, heart: 0, wishGiftId: 0),
    MicSeatState(
        state: 0, mute: 0, position: 8, charm: 0, heart: 0, wishGiftId: 0),
  ].obs;

  /// 正在说话的用户ID列表
  RxList<int> talkingUsers = <int>[].obs;

  @override
  RxList<MicSeatState> onSeatMics() {
    return mics;
  }

  @override
  RxList<int> onSeatTalkingUsers() {
    return talkingUsers;
  }

  ///获取在麦用户（礼物弹窗使用）
  @override
  List<GiftUserPositionInfo> onSeatMicUsers() {
    List<GiftUserPositionInfo> users = [];
    //获取主播
    // MicSeatState? micSeatStates = mics.firstWhereOrNull((element) =>
    //     element.user != null &&
    //     element.user?.id == logic.roomInfoObs.value?.userId);
    // if (micSeatStates != null) {
    //   users.add(
    //     GiftUserPositionInfo(
    //       position: 0,
    //       user: micSeatStates.user!,
    //     ),
    //   );
    // }
    //获取在麦用户
    for (var seat in mics) {
      ///过滤掉自己
      if (seat.user != null && seat.user?.id != UserController.to.id) {
        users.add(
            GiftUserPositionInfo(user: seat.user!, position: seat.position));
      }
    }
    return users;
  }

  ///麦位信息同步
  @override
  void onSeatSyncMics(List<SyncRoomSeat> syncRoomSeat) async {
    List<int> userIds = [];
    //获取在麦用户id数组
    for (var seat in syncRoomSeat) {
      if (seat.userId != -1) {
        userIds.add(seat.userId);
      }
    }
    //获取在麦用户信息数组
    List<UserInfo> users = [];
    int startTime = DateTime.now().millisecondsSinceEpoch;
    if (userIds.isNotEmpty) {
      try {
        var value =
            await LiveIndexLogic.to.request(AppApi.otherUserListUrl, params: {
          'user_ids': userIds.join(','),
        });
        users = (value.data as List).map((e) => UserInfo.fromJson(e)).toList();
      } catch (e) {
        //再试一次
        var value =
            await LiveIndexLogic.to.request(AppApi.otherUserListUrl, params: {
          'user_ids': userIds.join(','),
        });
        users = (value.data as List).map((e) => UserInfo.fromJson(e)).toList();
      }
    }
    //更新麦位信息
    List<MicSeatState> list = [];
    //syncRoomSeat 一定是9个
    for (var seat in syncRoomSeat) {
      int dataIndex = users.indexWhere((element) => element.id == seat.userId);
      list.add(
        MicSeatState(
          state: seat.state,
          mute: seat.mute,
          position: seat.position,
          charm: seat.charm,
          heart: seat.heart,
          wishGiftId: seat.wishGiftId,
          user: dataIndex != -1
              ? users[dataIndex].id == UserController.to.userInfo.value!.id
                  ? UserController.to.userInfo.value
                  : users[dataIndex]
              : null,
        ),
      );
    }
    mics.value = list;
    int endTime = DateTime.now().millisecondsSinceEpoch;
    int totalTime = endTime - startTime;
    LogUtils.onInfo('耗时-------${totalTime}ms');

    ///判断自己是否上下麦 (针对自己上下麦操作)
    int dataIndex = mics.indexWhere(
        (element) => element.user?.id == UserController.to.userInfo.value!.id);

    if (dataIndex > -1) {
      MicSeatState mySeat = mics[dataIndex];
      TRTCService().upMic(needChangeMuted: mySeat.mute == 1, mySeat: mySeat);
      if (mics[dataIndex].mute == 1) {
        TRTCService().closeMic();
      }
    } else {
      TRTCService().downMic();
      TRTCService().closeMic();
    }
  }

  ///上麦
  @override
  void onSeatUnMic() async {
    if (LiveIndexLogic.to.isOwner || LiveIndexLogic.to.isManager) {
      ///主播管理员上麦
      MicSeatState? micSeatStates =
          mics.firstWhereOrNull((element) => element.state == 0);
      if (micSeatStates != null) {
        await TRTCService().sendOnWheatChange(
            position: micSeatStates.position,
            mute: micSeatStates.mute,
            state: 1,
            userId: UserController.to.id);
      }
    } else {
      ///普通用户上麦
      MicSeatState? micSeatStates = mics.firstWhereOrNull(
          (element) => element.state == 0 && element.position != 0);
      if (micSeatStates != null) {
        await TRTCService().sendOnWheatChange(
            position: micSeatStates.position,
            mute: micSeatStates.mute,
            state: 1,
            userId: UserController.to.id);
      }
    }
  }

  ///下麦
  @override
  onSeatDownMic() async {
    MicSeatState? micSeatStates = mics.firstWhereOrNull(
        (element) => element.user?.id == UserController.to.id);
    if (micSeatStates != null) {
      await TRTCService().sendOnWheatChange(position: micSeatStates.position);
    }
  }

  ///是否在麦上
  @override
  bool onSeatCheckIsOnMic(int userId) {
    bool isOnMic = false;
    int dataIndex = mics.indexWhere((element) => element.user?.id == userId);
    if (dataIndex > -1) {
      return true;
    }
    return isOnMic;
  }

  ///是否禁麦
  @override
  bool onSeatCheckIsDisableMic(int userId) {
    bool isDisableMic = false;
    int dataIndex = mics.indexWhere((element) => element.user?.id == userId);
    if (dataIndex > -1 && mics[dataIndex].mute == 1) {
      return true;
    }
    return isDisableMic;
  }

  ///声音回调
  @override
  void onSeatVolumeChanged(List<UserVolume> userVolumes) {
    List<int> users = [];
    if (userVolumes.isNotEmpty) {
      for (UserVolume volume in userVolumes) {
        if (volume.volume > 20) {
          if (volume.userId == '') {
            users.add(UserController.to.id);
          } else {
            users.add(FormatUtil.getRealId(volume.userId));
          }
        }
      }
    }
    talkingUsers.sort((a, b) => a.compareTo(b));
    String oldUsers = talkingUsers.join(",");
    users.sort((a, b) => a.compareTo(b));
    String newUsers = users.join(",");
    if (oldUsers != newUsers) {
      talkingUsers.value = users;
    }
  }

  onClose() {}
}
