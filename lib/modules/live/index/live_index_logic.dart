import 'dart:async';
import 'package:get/get.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/gift.dart';
import 'package:youyu/models/room_detail_info.dart';
import 'package:youyu/modules/live/common/message/live_message.dart';
import 'package:youyu/modules/live/common/model/firend_state.dart';
import 'package:youyu/modules/live/common/model/world_msg_model.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:youyu/services/trtc/trtc_service.dart';
import 'package:youyu/utils/number_ext.dart';
import 'package:youyu/utils/tag_utils.dart';
import '../common/notification/live_index_notification.dart';
import 'operation/live_index_operation.dart';
import 'viewobs/live_index_view_obs.dart';
import 'package:youyu/modules/live/common/model/mic_seat_state.dart';
import 'package:youyu/widgets/gift/model/common_gift_pop_model.dart';
import 'package:youyu/models/room_background.dart';
import 'package:youyu/models/sync_room_seat.dart';
import 'package:youyu/modules/live/common/widget/bg/live_bg_widget.dart';
import 'package:youyu/services/trtc/model/user_volume.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dispatch/live_base_back_ground_bs.dart';
import 'dispatch/live_base_manager_bs.dart';
import 'dispatch/live_base_online_user_bs.dart';
import 'dispatch/live_base_seat_bs.dart';

///主逻辑（上下文）
class LiveIndexLogic extends AppBaseController
    with
        LiveBaseBackGroundBsListener,
        LiveBaseManagerBsListener,
        LiveBaseOnlineUserBsListener,
        LiveBaseSeatBsListener {
  static LiveIndexLogic get to =>
      Get.find<LiveIndexLogic>(tag: AppTapUtils.tag);

  late LiveIndexViewObs viewObs;
  late LiveIndexOperation operation;
  LiveIndexNotification? notification;

  ///页面tag
  late String pageTag;

  ///参数
  //直播id
  late int roomId;

  //直播间靓号
  int liveFancyNumber = 0;

  //im id
  late String imGroupId;

  //是否是房主
  bool isOwner = false;

  //房主id
  late int ownerId;

  //是否是管理员
  bool isManager = false;

  //是否开启连麦申请
  bool isOpenLink = false;

  //是否是主持
  bool isHost = false;

  //是否关闭动效
  var isCloseAni = false.obs;

  //是否关闭公屏
  var isCloseScreen = false.obs;

  //是否被禁言
  bool isMute = false;

  //是否小窗口进入
  bool isFloatEnter = false;

  //直播间数据
  Rx<RoomDetailInfo?> roomInfoObs = Rx(null);

  //邂逅数据
  Rx<FriendState?> friendStateObs = Rx(null);

  ///业务分发
  //背景图
  final LiveBaseBackGroundBs _bgBusiness = LiveBaseBackGroundBs();

  //管理员
  final LiveBaseManagerBs _managerBusiness = LiveBaseManagerBs();

  //在线用户
  final LiveBaseOnlineUserBs _onlineUserBusiness = LiveBaseOnlineUserBs();

  //麦位
  final LiveBaseSeatBs _seatBusiness = LiveBaseSeatBs();

  //世界消息
  Rx<WorldMsg?> liveWorldMsgObs = Rx(null);

  //心愿礼物列表
  List<Gift?> barGiftList = [];

  //撩一撩礼物
  Gift? flirtGift;

  @override
  void onInit() async {
    super.onInit();
    viewObs = LiveIndexViewObs();
    operation = LiveIndexOperation();
    notification = LiveIndexNotification();

    pageTag = AppTapUtils.tag;
    roomId = Get.arguments['roomId'];
    imGroupId = Get.arguments['groupId'];
    roomInfoObs.value = Get.arguments['roomInfo'];
    isFloatEnter = Get.arguments['isFloatEnter'];
    liveFancyNumber = roomInfoObs.value?.fancyNumber ?? 0;
    if (roomInfoObs.value?.userId == UserController.to.id) {
      isOwner = true;
    } else {
      isOwner = false;
    }
    ownerId = roomInfoObs.value?.userId ?? 0;
    if (roomInfoObs.value?.isSpeak == 1) {
      isCloseScreen.value = false;
    } else {
      isCloseScreen.value = true;
    }
    isMute = (roomInfoObs.value?.isMute == 1);
    ///进房记录
    _addLiveAccess();
  }

  @override
  void onReady() {
    super.onReady();
    //开启通知监听
    notification?.onStart(roomInfoObs: roomInfoObs);
    //处理房间信息
    _dealWithRoomInfo();
  }

  ///处理房间信息
  _dealWithRoomInfo() async {
    LiveService().isInLive = true;
    //0...
    updateRoomInfo();
    //7.管理员列表
    onManagerUpdate();
    //8.欢迎语
    notification?.screenNotify.insertWelComeMessage(roomInfoObs.value?.welcome);
    //9.发送socket
    notification?.sendMsg.sendWsJoin();
    //10.获取打赏记录
    // notification?.initGiftNotice();
    if (!isFloatEnter) {
      ///公屏消息
      LiveMessageModel model = LiveMessageModel(
          isManager: false, type: LiveMessageType.topSpace, data: null);
      TRTCService().allScreenList.add(model);
      TRTCService().chatScreenList.add(model);
      TRTCService().giftScreenList.add(model);
    }
    //11.刷新主页面
    setSuccessType();
    //12.直播服务
    if (isFloatEnter) {
      refreshRoomInfo(() {
        updateRoomInfo();
      });
      TRTCService().currentRoomInfo = roomInfoObs;
    } else {
      await TRTCService().joinTRTCRoom(
          roomId: roomId, groupId: imGroupId, roomDetailInfo: roomInfoObs);
      //13.发送进入房间消息
      notification?.sendMsg.sendJoinMessage();
      //13.1 默认关闭麦
      TRTCService().closeMic();
    }
    //14.开启定时刷新房间用户
    Future.delayed(const Duration(milliseconds: 100), () {
      onOnlineUserUpdateTimerStart();
    });

    //14.2 礼物飘屏top
    viewObs.giftSlideTop.value = viewObs.giftNormalSlideTop;

    //15.交友房获取邂逅信息
    getFriendInfo();

    //16.酒吧房获取礼物列表
    getBarGiftList();

    //17.酒吧房获取撩一撩礼物
    getFlirtGift();
  }

  updateRoomInfo() {
    //0.标题
    viewObs.name.value = roomInfoObs.value?.name ?? "";
    //1.类型
    viewObs.roomType.value = roomInfoObs.value?.typeName ?? "";
    //2.房间背景
    if (roomInfoObs.value?.background != null) {
      viewObs.roomBackInfo.value = roomInfoObs.value!.background;
      onBackGroundProgress(viewObs.roomBackInfo.value);
    }
    //3.公告
    viewObs.notice.value = roomInfoObs.value?.announcement ?? "";
    //4.热度
    viewObs.liveHot.value = (roomInfoObs.value?.heat ?? 0).showNum();
    //5.是否关注
    viewObs.isFocusLive.value = roomInfoObs.value?.isFollowRoom ?? 0;
    //6.是否加锁
    viewObs.lock.value = roomInfoObs.value?.lock ?? 0;
  }

  ///刷新房间信息
  void refreshRoomInfo(Function onUpdate) {
    request(AppApi.liveInfoUrl,
            params: {"room_id": roomId}, isPrintLog: true, isShowToast: false)
        .then((value) async {
      roomInfoObs.value = RoomDetailInfo.fromJson(value.data);
      onUpdate();
    });
  }

  ///新增直播房间记录
  _addLiveAccess() {
    request(AppApi.userAddAccessUrl,
        params: {'room_id': roomInfoObs.value?.id ?? 0, 'type': 2},
        isShowToast: false,
        isPrintLog: false);
  }

  ///获取打赏记录
  getGiftRecord() async {
    return request(
      AppApi.roomRewardLogUrl,
      params: {
        'room_id': roomInfoObs.value?.id ?? 0,
      },
      isShowToast: false,
    );
  }

  ///刷新热度
  refreshHeat() async {
    return request(
      AppApi.liveHeatUrl,
      params: {
        'room_id': roomInfoObs.value?.id ?? 0,
      },
      isShowToast: false,
    );
  }

  ///房间邂逅信息
  getFriendInfo() {
    request(
      AppApi.liveFriendInfoUrl,
      params: {
        'room_id': roomInfoObs.value?.id ?? 0,
      },
      isShowToast: true,
    ).then((value) async {
      debugPrint("*****************${value.data}");
      friendStateObs.value = FriendState.fromJson(value.data);
      debugPrint("*****************${friendStateObs.value?.status}");
    });
  }

  ///开启邂逅
  friendopen() {
    request(
      AppApi.liveFriendOpenUrl,
      params: {
        'room_id': roomInfoObs.value?.id ?? 0,
      },
      isShowToast: true,
    ).then((value) async {
      debugPrint("*****************${value.code}");
    });
  }

  ///关闭邂逅
  friendend(friendsId) async {
    return request(
      AppApi.liveFriendEndUrl,
      params: {'room_id': roomInfoObs.value?.id ?? 0, 'friends_id': friendsId},
      isShowToast: false,
    );
  }

  ///增加邂逅时间
  friendaddtime(friendsId) async {
    return request(
      AppApi.liveFriendIncreaseUrl,
      params: {'room_id': roomInfoObs.value?.id ?? 0, 'friends_id': friendsId},
      isShowToast: false,
    );
  }

  ///酒吧礼物列表
  getBarGiftList() {
    request(
      AppApi.LiveBarGiftList,
      isShowToast: true,
    ).then((value) async {
      debugPrint("*****************${value.data}");
      for (var temp in value.data) {
        barGiftList.add(Gift.fromJson(temp));
      }
    });
  }

  ///酒吧撩一撩礼物
  getFlirtGift() {
    request(
      AppApi.LiveBarFlirtGiftId,
      isShowToast: true,
    ).then((value) async {
      debugPrint("*****************${value.data}");
      flirtGift = Gift.fromJson(value.data);
    });
  }

  ///LiveBaseBackGroundBsListener
  @override
  GlobalKey<LiveBgWidgetState> onBackGroundKey() {
    return _bgBusiness.onBackGroundKey();
  }

  @override
  void onBackGroundProgress(RoomBackGround? backGround) {
    _bgBusiness.onBackGroundProgress(backGround);
  }

  ///LiveBaseManagerBsListener
  @override
  void onManagerUpdate() {
    _managerBusiness.onManagerUpdate();
  }

  @override
  void onAddManager(int userId) {
    _managerBusiness.onAddManager(userId);
  }

  @override
  void onRemoveManager(int userId) {
    _managerBusiness.onRemoveManager(userId);
  }

  @override
  bool onManagerById(int userId) {
    return _managerBusiness.onManagerById(userId);
  }

  ///LiveBaseOnlineUserBsListener
  @override
  onOnlineUserUpdateTimerStart() {
    _onlineUserBusiness.onOnlineUserUpdateTimerStart();
  }

  @override
  onOnlineUserForceUpdate() {
    _onlineUserBusiness.onOnlineUserForceUpdate();
  }

  ///LiveBaseSeatBsListener
  @override
  List<GiftUserPositionInfo> onSeatMicUsers() {
    return _seatBusiness.onSeatMicUsers();
  }

  @override
  RxList<MicSeatState> onSeatMics() {
    return _seatBusiness.onSeatMics();
  }

  @override
  RxList<int> onSeatTalkingUsers() {
    return _seatBusiness.onSeatTalkingUsers();
  }

  @override
  void onSeatSyncMics(List<SyncRoomSeat> syncRoomSeat) {
    _seatBusiness.onSeatSyncMics(syncRoomSeat);
  }

  @override
  void onSeatUnMic() {
    _seatBusiness.onSeatUnMic();
  }

  @override
  Future<void> onSeatDownMic() async {
    await _seatBusiness.onSeatDownMic();
  }

  @override
  bool onSeatCheckIsDisableMic(int userId) {
    return _seatBusiness.onSeatCheckIsDisableMic(userId);
  }

  @override
  bool onSeatCheckIsOnMic(int userId) {
    return _seatBusiness.onSeatCheckIsOnMic(userId);
  }

  @override
  void onSeatVolumeChanged(List<UserVolume> userVolumes) {
    _seatBusiness.onSeatVolumeChanged(userVolumes);
  }

  @override
  void onResumed() {
    super.onResumed();
    notification?.sendMsg.sendWsJoin();
  }

  @override
  void onClose() async {
    await viewObs.onClose();
    await notification?.onClose();
    await operation.onClose();
    await _bgBusiness.onClose();
    await _managerBusiness.onClose();
    await _onlineUserBusiness.onClose();
    super.onClose();
  }
}
