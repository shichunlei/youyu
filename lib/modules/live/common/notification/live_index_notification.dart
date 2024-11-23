import 'dart:convert';
import 'package:youyu/modules/live/common/model/firend_state.dart';
import 'package:youyu/modules/live/common/model/world_msg_model.dart';
import 'package:youyu/modules/live/common/notification/send/live_index_send_msg.dart';
import 'package:youyu/modules/live/common/model/mic_seat_state.dart';
import 'package:youyu/modules/live/index/live_index_logic.dart';
import 'package:youyu/utils/time_utils.dart';
import 'package:youyu/utils/toast_utils.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/gift.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/models/room_detail_info.dart';
import 'package:youyu/models/sync_room_seat.dart';
import 'package:youyu/modules/live/common/message/live_message.dart';
import 'package:youyu/modules/live/common/message/sub/live_gift_msg.dart';
import 'package:youyu/modules/live/common/message/sub/live_join_msg.dart';
import 'package:youyu/modules/live/common/notification/abs/live_notification.dart';
import 'package:youyu/services/async_down_service.dart';
import 'package:youyu/services/im/im_listener.dart';
import 'package:youyu/services/im/im_service.dart';
import 'package:youyu/services/im/model/ext/im_forbidden_model.dart';
import 'package:youyu/services/im/model/ext/im_gift_model.dart';
import 'package:youyu/services/im/model/ext/im_hug_up_mic_model.dart';
import 'package:youyu/services/im/model/ext/im_kick_out_model.dart';
import 'package:youyu/services/im/model/ext/im_manager_model.dart';
import 'package:youyu/services/im/model/ext/im_room_setting_model.dart';
import 'package:youyu/services/im/model/ext/im_screen_speak_model.dart';
import 'package:youyu/services/im/model/ext/im_slide_gift_model.dart';
import 'package:youyu/services/im/model/im_custom_message_mdoel.dart';
import 'package:youyu/services/im/model/im_msg_type.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:youyu/services/socket/socket_msg_type.dart';
import 'package:youyu/services/socket/socket_service.dart';
import 'package:youyu/services/trtc/model/user_volume.dart';
import 'package:youyu/services/trtc/trtc_service.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/utils/format_utils.dart';
import 'package:youyu/utils/number_ext.dart';
import 'package:youyu/widgets/app/dialog/app_tip_dialog.dart';
import 'package:get/get.dart';
import 'package:tencent_im_sdk_plugin_platform_interface/models/v2_tim_group_member_info.dart';
import 'package:tencent_im_sdk_plugin_platform_interface/models/v2_tim_message.dart';

///消息监听
class LiveIndexNotification extends LiveNotification
    with
        IMMessageReceiveListener,
        IMMessageGroupListener,
        SocketServiceReceiveListener,
        UserVoiceVolumeListener {
  ///发送消息管理
  late LiveIndexSendMsg sendMsg;

  //TODO:先放这里
  bool isShowHugUpMic = false;

  onStart(
      {LiveNotification? notification,
      required Rx<RoomDetailInfo?> roomInfoObs}) {
    ///初始化分发通知
    screenNotify.onStart(notification: this, roomInfoObs: roomInfoObs);
    topSlideNotify.onStart(notification: this, roomInfoObs: roomInfoObs);
    tipSlideNotify.onStart(notification: this, roomInfoObs: roomInfoObs);
    joinSlideNotify.onStart(notification: this, roomInfoObs: roomInfoObs);
    giftSlideNotify.onStart(notification: this, roomInfoObs: roomInfoObs);
    vipSlideNotify.onStart(notification: this, roomInfoObs: roomInfoObs);
    settingNotify.onStart(notification: this, roomInfoObs: roomInfoObs);

    ///消息发送管理
    sendMsg = LiveIndexSendMsg();
    sendMsg.sendMessageSuc = _imSendSuc;

    ///websocket监听
    SocketService().addWSServiceListener(this);

    ///im监听
    IMService().addImReceiveMessageListener(this);
    IMService().addImGroupListener(this);

    ///声音监听
    TRTCService().volumeListener = this;
  }

  ///ws - SocketServiceReceiveListener
  @override
  onWSConnectSuccess() {
    sendMsg.sendWsJoin();
  }

  @override
  onWSReceiveMessage(String type, data) {
    switch (type) {
      case SocketMessageType.actionWheat:
        List<SyncRoomSeat> seats =
            (data as List).map((e) => SyncRoomSeat.fromJson(e)).toList();
        LiveIndexLogic.to.onSeatSyncMics(seats);
        break;
      case SocketMessageType.joinRoom:
        //麦位信息同步
        List<SyncRoomSeat> seats =
            (data as List).map((e) => SyncRoomSeat.fromJson(e)).toList();
        LiveIndexLogic.to.onSeatSyncMics(seats);
        break;
      case SocketMessageType.floatingScreen:
        {
          //TODO:这里同步im - 礼物飘屏消息
          IMCustomMessageModel<IMSlideGiftModel> imModel =
              IMCustomMessageModel<IMSlideGiftModel>.fromJson(
                  IMMsgType.getTypeByType("slide_gift"), data);
          topSlideNotify.insertTopSlide(imModel,
              LiveIndexLogic.to.onManagerById(imModel.userInfo?.id ?? 0));
          // refreshHeat();
        }
        break;
      case SocketMessageType.boxGiftList:
        break;
      case SocketMessageType.friendsOpen:
        LiveIndexLogic.to.friendStateObs.value = FriendState.fromJson(data);
        LiveIndexLogic.to.getFriendInfo();
        break;
      case SocketMessageType.friendsEnd:
        LiveIndexLogic.to.friendStateObs.value = FriendState.fromJson(data);
        // LiveIndexLogic.to.getFriendInfo();
        if (LiveIndexLogic.to.friendStateObs.value?.status == 2 &&
            data['is_open'] == 1) {
          LiveIndexLogic.to.operation.onOperateRelation();
        }
        break;
      case SocketMessageType.friendsTime:
        LiveIndexLogic.to.friendStateObs.value = FriendState.fromJson(data);
        LiveIndexLogic.to.getFriendInfo();
        break;

      ///
      case SocketMessageType.worldMsg:
        var temp = data;
        if (temp == null) {
          LiveIndexLogic.to.liveWorldMsgObs.value = WorldMsg.fromJson({});
        } else {
          LiveIndexLogic.to.liveWorldMsgObs.value = WorldMsg.fromJson(data);
        }
        // if ((temp as List).isNotEmpty) {
        //   LiveIndexLogic.to.liveWorldMsgObs.value = WorldMsg.fromJson(data);
        // } else {
        //   LiveIndexLogic.to.liveWorldMsgObs.value = WorldMsg.fromJson({});
        // }

        //todo 世界消息通知
        break;

      ///ws推送直播间热度
      case SocketMessageType.liveHeat:
        refreshHeat(data);
      default:
        break;
    }
  }

  ///im监听 - IMMessageReceiveListener
  @override
  onReceiveMessage(V2TimMessage msg) {
    IMMsgType msgType = IMMsgType.getTypeByType(msg.customElem?.desc ?? "");

    ///礼物飘屏 需要全服通知
    if (msg.groupID == LiveIndexLogic.to.imGroupId ||
        msgType == IMMsgType.slideGift) {
      _imMessageProcess(msgType, msg);
    }
  }

  ///IM群组监听 - IMMessageGroupListener
  @override
  onMemberEnter(String groupID, List<V2TimGroupMemberInfo> memberList) async {
    LiveIndexLogic.to.onManagerUpdate();
    await 0.5.delay();
    LiveIndexLogic.to.onOnlineUserForceUpdate();
  }

  @override
  onMemberLeave(String groupID, V2TimGroupMemberInfo member) async {
    await 0.5.delay();
    LiveIndexLogic.to.onOnlineUserForceUpdate();
  }

  ///im消息处理
  _imSendSuc(IMMsgType msgType, V2TimMessage message) {
    _imMessageProcess(msgType, message, isSend: true);
  }

  _imMessageProcess(IMMsgType msgType, V2TimMessage message,
      {bool isSend = false}) {
    switch (msgType) {
      case IMMsgType.liveRoomText:
        //文字消息
        screenNotify.insertTextMessage(
            message,
            LiveIndexLogic.to
                .onManagerById(FormatUtil.getRealId(message.sender ?? "")));
        break;
      case IMMsgType.groupAt:
        //群at消息
        screenNotify.insertAtTextMessage(
            message,
            LiveIndexLogic.to
                .onManagerById(FormatUtil.getRealId(message.sender ?? "")));

        break;
      case IMMsgType.gift:
        //礼物消息
        if (message.customElem?.data != null) {
          //1.添加公屏
          IMCustomMessageModel<IMGiftModel> imModel =
              IMCustomMessageModel<IMGiftModel>.fromJson(
                  IMMsgType.getTypeByType(message.customElem?.desc ?? ""),
                  jsonDecode(message.customElem?.data ?? ""));
          LiveMessageModel<LiveGiftMsg> giftModel =
              screenNotify.insertGiftMessage(
                  imModel,
                  LiveIndexLogic.to.onManagerById(
                      FormatUtil.getRealId(message.sender ?? "")),
                  false);
          //2.礼物动画相关
          giftSlideNotify.insertGiftModel(giftModel);
          //3.播放礼物动效
          if (imModel.data?.gift?.playSvg == 1) {
            if (!LiveIndexLogic.to.isCloseAni.value) {
              AsyncDownService().addTask(DownType.bigGifAni,
                  DownModel(url: (imModel.data?.gift?.svg ?? "")));
            }
          }
          //4.添加礼物记录
          // _insertGiftNotice(imModel.userInfo?.nickname ?? "", imModel.data,
          //     imModel.timestamp ?? 0,
          //     isSend: isSend);
        }
        // refreshHeat();
        break;
      case IMMsgType.luckyGift:
        //福袋礼物消息
        if (message.customElem?.data != null) {
          //1.先获取福袋消息
          IMCustomMessageModel<IMGiftModel> tImModel =
              IMCustomMessageModel<IMGiftModel>.fromJson(
                  IMMsgType.getTypeByType(message.customElem?.desc ?? ""),
                  jsonDecode(message.customElem?.data ?? ""));
          //2.拿到子列表
          List<Gift> childList = [];
          childList.addAll(tImModel.data?.gift?.childList ?? []);
          //2.去除福袋中的礼物列表
          for (var element in childList) {
            IMCustomMessageModel<IMGiftModel> tempImModel =
                IMCustomMessageModel<IMGiftModel>.fromJson(
                    IMMsgType.getTypeByType(message.customElem?.desc ?? ""),
                    jsonDecode(message.customElem?.data ?? ""));
            //礼物处理
            tempImModel.data?.gift?.childList?.clear();
            tempImModel.data?.gift?.childList?.add(element);

            IMCustomMessageModel<IMGiftModel> giftImModel =
                IMCustomMessageModel(
                    userInfo: tempImModel.userInfo,
                    data: IMGiftModel(
                        gift: tempImModel.data?.gift,
                        receiver: tempImModel.data?.receiver),
                    timestamp: tempImModel.timestamp,
                    loss_time: tempImModel.loss_time);

            LiveMessageModel<LiveGiftMsg> giftModel =
                screenNotify.insertGiftMessage(
                    giftImModel,
                    LiveIndexLogic.to.onManagerById(
                        FormatUtil.getRealId(message.sender ?? "")),
                    true);

            //2.礼物动画相关
            giftSlideNotify.insertGiftModel(giftModel);
          }
          // LiveMessageModel<LiveGiftMsg> giftModel =
          //     screenNotify.insertGiftMessage(
          //         imModel,
          //         logic.business?.onManagerById(
          //                 FormatUtil.getRealId(message.sender ?? "")) ??
          //             false,
          //         true);
          //3.添加礼物记录
          // _insertGiftNotice(tImModel.userInfo?.nickname ?? "", tImModel.data,
          //     tImModel.timestamp ?? 0,
          //     isSend: isSend);
          if (!isSend) {
            //4.播放礼物动效
            for (Gift subGift in tImModel.data?.gift?.childList ?? []) {
              if (subGift.playSvg == 1) {
                if (!LiveIndexLogic.to.isCloseAni.value) {
                  AsyncDownService().addTask(
                      DownType.bigGifAni, DownModel(url: (subGift.svg ?? "")));
                }
              }
            }
          }
        }
        // refreshHeat();
        break;
      case IMMsgType.joinRoom:
        //加入房间消息
        LiveMessageModel<LiveJoinMsg> model =
            screenNotify.insertJoinRoomMessage(
                message,
                LiveIndexLogic.to
                    .onManagerById(FormatUtil.getRealId(message.sender ?? "")));
        joinSlideNotify.insertJoinMessage(model);

        IMCustomMessageModel imModel = IMCustomMessageModel.fromJson(
            IMMsgType.getTypeByType(message.customElem?.desc ?? ""),
            jsonDecode(message.customElem?.data ?? ""));
        if (!LiveIndexLogic.to.isCloseAni.value) {
          AsyncDownService().addTask(DownType.bigGifAni,
              DownModel(url: (imModel.userInfo!.dressCar()?.res ?? "")));
        }

        break;
      case IMMsgType.slideGift:
        //礼物飘屏消息
        IMCustomMessageModel<IMSlideGiftModel> imModel =
            IMCustomMessageModel<IMSlideGiftModel>.fromJson(
                IMMsgType.getTypeByType(message.customElem?.desc ?? ""),
                jsonDecode(message.customElem?.data ?? ""));

        int lossTime = imModel.loss_time ?? 0;
        if (TimeUtils.nowTimeDiff(lossTime * 1000) > 0) {
          topSlideNotify.insertTopSlide(
              imModel,
              LiveIndexLogic.to
                  .onManagerById(FormatUtil.getRealId(message.sender ?? "")));
          // refreshHeat();
        }
        break;
      case IMMsgType.screenSpeak:
        //公平打开/关闭消息
        IMCustomMessageModel<IMScreenSpeakMsg> imModel =
            IMCustomMessageModel<IMScreenSpeakMsg>.fromJson(
                IMMsgType.getTypeByType(message.customElem?.desc ?? ""),
                jsonDecode(message.customElem?.data ?? ""));
        if (imModel.data?.isSpeak == 1) {
          LiveIndexLogic.to.isCloseScreen.value = false;
        } else {
          LiveIndexLogic.to.isCloseScreen.value = true;
          //关闭输入
          LiveIndexLogic.to.operation.onOperateDismissInputAndEmoji();
        }
        break;
      case IMMsgType.roomSetting:
        //房间设置消息
        IMCustomMessageModel<IMRoomSettingMsg> imModel =
            IMCustomMessageModel<IMRoomSettingMsg>.fromJson(
                IMMsgType.getTypeByType(message.customElem?.desc ?? ""),
                jsonDecode(message.customElem?.data ?? ""));
        if (imModel.data != null) {
          _updateRoomInfo(imModel.data!.settingType, imModel.data!.roomInfo);
        }
        break;
      case IMMsgType.manager:
        //管理员消息
        IMCustomMessageModel<IMSyncManagerMsg> imModel =
            IMCustomMessageModel<IMSyncManagerMsg>.fromJson(
                IMMsgType.getTypeByType(message.customElem?.desc ?? ""),
                jsonDecode(message.customElem?.data ?? ""));
        if (imModel.data?.status == 0) {
          //移除
          LiveIndexLogic.to.onRemoveManager(imModel.data?.user.id ?? 0);
        } else if (imModel.data?.status == 1) {
          //添加
          LiveIndexLogic.to.onAddManager(imModel.data?.user.id ?? 0);
          screenNotify.insertManagerMessage(
              imModel,
              LiveIndexLogic.to
                  .onManagerById(FormatUtil.getRealId(message.sender ?? "")));
        }
        break;
      case IMMsgType.hugUpMicMsg:
        //抱上麦消息
        IMCustomMessageModel<IMHugUpMicMsg> imModel =
            IMCustomMessageModel<IMHugUpMicMsg>.fromJson(
                IMMsgType.getTypeByType(message.customElem?.desc ?? ""),
                jsonDecode(message.customElem?.data ?? ""));
        if (imModel.data?.userInfo.id == UserController.to.id) {
          if (TRTCService().currentSeatState != null) {
            //如果已经上麦，就不处理
            return;
          }
          //防止重复弹窗
          if (isShowHugUpMic) {
            Get.back();
          }
          isShowHugUpMic = true;
          //弹窗提示
          AppTipDialog().showTipDialog("提示", AppWidgetTheme.dark,
              onWillPop: false, msg: "邀请你上麦，是否上麦？", onCommit: () {
            isShowHugUpMic = false;
            if (LiveIndexLogic.to.onSeatMics().isNotEmpty == true) {
              MicSeatState? micSeatState;
              if ((imModel.data?.position ?? -1) > -1) {
                micSeatState = LiveIndexLogic.to.onSeatMics().firstWhere(
                    (element) => element.position == imModel.data?.position);
              } else {
                micSeatState = LiveIndexLogic.to.onSeatMics().firstWhere(
                    (element) => element.state == 0 && element.position != 0);
              }
              if (micSeatState.state == 0) {
                TRTCService().sendOnWheatChange(
                    position: micSeatState.position,
                    state: 1,
                    mute: micSeatState.mute,
                    userId: imModel.data?.userInfo.id ?? 0);
              } else if (micSeatState.state == 1) {
                ToastUtils.show("麦位已经有人");
              } else {
                ToastUtils.show("麦位已锁");
              }
            } else {
              TRTCService().sendOnWheatChange(
                  position: imModel.data?.position ?? 1,
                  state: 1,
                  userId: imModel.data?.userInfo.id ?? 0);
            }
          }, onCancel: () {
            isShowHugUpMic = false;
          });
        }

        break;
      case IMMsgType.forbidden:
        //禁言
        IMCustomMessageModel<IMForbiddenMsg> imModel =
            IMCustomMessageModel<IMForbiddenMsg>.fromJson(
                IMMsgType.getTypeByType(message.customElem?.desc ?? ""),
                jsonDecode(message.customElem?.data ?? ""));
        if (imModel.data?.userInfo.id == UserController.to.id) {
          if (imModel.data?.userInfo.isMuted == 1) {
            LiveIndexLogic.to.isMute = true;
            ToastUtils.show("您已被禁言");
          } else {
            LiveIndexLogic.to.isMute = false;
            ToastUtils.show("您已被解除禁言");
          }
        }
        break;
      case IMMsgType.kickOut:
        //踢出群
        IMCustomMessageModel<IMKickOutMsg> imModel =
            IMCustomMessageModel<IMKickOutMsg>.fromJson(
                IMMsgType.getTypeByType(message.customElem?.desc ?? ""),
                jsonDecode(message.customElem?.data ?? ""));
        if (imModel.data?.userInfo.id == UserController.to.id) {
          LiveIndexLogic.to.operation.onOperateLeave();
          ToastUtils.show("您已被踢出群");
        }
        break;
      case IMMsgType.joinRoomWithDressCar:
        if (!LiveIndexLogic.to.isCloseAni.value) {
          AsyncDownService().addTask(
              DownType.bigGifAni,
              DownModel(
                  url: '${UserController.to.userInfo.value?.dressCar()?.res}'));
        }

      default:
        break;
    }
  }

  ///声音监听
  @override
  onUserVoiceVolume(List<UserVolume> list) {
    LiveIndexLogic.to.onSeatVolumeChanged(list);
  }

  ///直播间设置监听
  @override
  roomSettingNotify(
      LiveSettingType settingType, RoomDetailInfo roomDetailInfo) {
    _updateRoomInfo(settingType, roomDetailInfo);

    ///发送im
    sendMsg.sendRoomSettingMessage(settingType, roomDetailInfo);
  }

  _updateRoomInfo(LiveSettingType settingType, RoomDetailInfo roomDetailInfo) {
    LiveIndexLogic.to.roomInfoObs.value = roomDetailInfo;
    switch (settingType) {
      case LiveSettingType.roomName:
        LiveIndexLogic.to.viewObs.name.value = roomDetailInfo.name ?? "";
        break;
      case LiveSettingType.roomType:
        LiveIndexLogic.to.viewObs.roomType.value =
            roomDetailInfo.typeName ?? "";
        break;
      case LiveSettingType.roomAnnouncement:
        LiveIndexLogic.to.viewObs.notice.value =
            roomDetailInfo.announcement ?? "";
        break;
      case LiveSettingType.roomBg:
        LiveIndexLogic.to.onBackGroundProgress(roomDetailInfo.background);
        break;
      case LiveSettingType.roomLock:
        LiveIndexLogic.to.viewObs.lock.value = roomDetailInfo.lock ?? 0;
        break;
      default:
        break;
    }
  }

  ///管理员设置监听
  @override
  roomSetManagerNotify({required int status, required UserInfo userInfo}) {
    if (status == 0) {
      //移除
      LiveIndexLogic.to.onRemoveManager(userInfo.id ?? 0);
    } else if (status == 1) {
      //添加
      LiveIndexLogic.to.onAddManager(userInfo.id ?? 0);
    }
    sendMsg.sendManagerMsg(status, userInfo);
  }

  //解除禁言
  @override
  roomRemoveForbidden(UserInfo userInfo) {
    LiveIndexLogic.to.notification?.sendMsg.sendForbiddenMsg(userInfo);
  }

  //刷新热度
  refreshHeat(value) async {
    try {
      // var value = await LiveIndexLogic.to.refreshHeat();
      LiveIndexLogic.to.viewObs.liveHot.value = (value as int).showNum();
    } catch (e) {
      //...
    }
  }

  ///打赏记录
  // initGiftNotice() async {
  //   try {
  //     var value = await LiveIndexLogic.to.getGiftRecord();
  //     List<dynamic> list = value.data;
  //     for (Map<String, dynamic> map in list) {
  //       GiftRecord entity = GiftRecord.fromJson(map);
  //       giftSlideNotify.insertGiftNotice(entity);
  //     }
  //   } catch (e) {
  //     //...
  //   }
  // }

  // _insertGiftNotice(String sendUserName, IMGiftModel? giftModel, int createTime,
  //     {bool isSend = false}) {
  //   if (giftModel != null) {
  //     if (isSend) {
  //       LiveIndexLogic.to.request(AppApi.roomRewardLogAddUrl, params: {
  //         'room_id': LiveIndexLogic.to.roomId,
  //         'user_name': sendUserName,
  //         'to_user_name': giftModel.receiver?.nickname,
  //         'gift_name': giftModel.gift?.name,
  //         'num': giftModel.gift?.count,
  //         'image': giftModel.gift?.image
  //       }).then((value) {
  //         GiftRecord entity = GiftRecord(
  //             userName: sendUserName,
  //             toUserName: giftModel.receiver?.nickname,
  //             giftName: giftModel.gift?.name,
  //             num: giftModel.gift?.count,
  //             createTime: createTime,
  //             image: giftModel.gift?.image);
  //         giftSlideNotify.insertGiftNotice(entity);
  //       });
  //     } else {
  //       GiftRecord entity = GiftRecord(
  //           userName: sendUserName,
  //           toUserName: giftModel.receiver?.nickname,
  //           giftName: giftModel.gift?.name,
  //           num: giftModel.gift?.count,
  //           createTime: createTime,
  //           image: giftModel.gift?.image);
  //       giftSlideNotify.insertGiftNotice(entity);
  //     }
  //   }
  // }

  Future<void> onClose() async {
    screenNotify.onClose();
    topSlideNotify.onClose();
    tipSlideNotify.onClose();
    joinSlideNotify.onClose();
    giftSlideNotify.onClose();
    vipSlideNotify.onClose();
    settingNotify.onClose();
    TRTCService().volumeListener = null;
    IMService().removeImReceiveMessageListener(this);
    IMService().removeImGroupListener(this);
    SocketService().removeWSServiceListener(this);
    await Future.delayed(Duration(seconds: 1));
  }
}
