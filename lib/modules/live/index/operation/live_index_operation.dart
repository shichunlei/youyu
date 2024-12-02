import 'package:flutter/material.dart';
import 'package:youyu/config/config.dart';
import 'package:youyu/models/gift_game.dart';
import 'package:youyu/modules/live/common/interactor/pop/gift/give/live_pop_give_gift_index.dart';
import 'package:youyu/modules/live/common/interactor/pop/headline/live_pop_world_msg.dart';
import 'package:youyu/modules/live/common/interactor/pop/link/user/live_link_user_widget.dart';
import 'package:youyu/modules/live/common/interactor/pop/relation/live_pop_relation_index.dart';
import 'package:youyu/modules/live/common/model/mic_seat_state.dart';
import 'package:youyu/modules/live/game/wheel/index/wheel_game_view_view.dart';
import 'package:youyu/modules/live/index/live_index_logic.dart';
import 'package:youyu/services/game/game_service.dart';
import 'package:youyu/utils/toast_utils.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/services/trtc/trtc_service.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/models/room_list_item.dart';
import 'package:youyu/modules/live/common/interactor/pop/close/live_pop_close.dart';
import 'package:youyu/modules/live/common/interactor/pop/compere/live_compere_widget.dart';
import 'package:youyu/modules/live/common/interactor/pop/input/live_pop_input.dart';
import 'package:youyu/modules/live/common/interactor/pop/link/owner/live_link_owner_widget.dart';
import 'package:youyu/modules/live/common/interactor/pop/more/live_pop_bottom_more.dart';
import 'package:youyu/modules/live/common/interactor/pop/more/live_pop_bottom_more_logic.dart';
import 'package:youyu/modules/live/common/interactor/pop/notice/live_pop_notice.dart';
import 'package:youyu/modules/live/common/interactor/pop/share/live_pop_share.dart';
import 'package:youyu/modules/live/common/interactor/pop/user/live_pop_user.dart';
import 'package:youyu/modules/live/common/interactor/pop/userlist/live_pop_user_list.dart';
import 'package:youyu/modules/live/common/message/live_message.dart';
import 'package:youyu/modules/live/common/message/sub/live_manager_msg.dart';
import 'package:youyu/modules/live/common/widget/conversation/live_conversation_view.dart';
import 'package:youyu/modules/live/common/widget/message/live_message_detail_view.dart';
import 'package:youyu/modules/live/common/widget/ml/live_clear_charm_sheet.dart';
import 'package:youyu/modules/submod/report/report_logic.dart';
import 'package:youyu/router/router.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/utils/format_utils.dart';
import 'package:youyu/widgets/app/actionsheet/app_action_ext_sheet.dart';
import 'package:youyu/widgets/app/actionsheet/app_action_sheet.dart';
import 'package:youyu/widgets/app/other/emoji/app_emoji_widget.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/models/localmodel/item_title_model.dart';
import 'package:youyu/models/localmodel/menu_model.dart';
import 'package:youyu/widgets/app/other/emoji/model/app_custom_emoji_item.dart';
import 'package:youyu/widgets/gift/common_gift_pop_view.dart';
import 'package:youyu/widgets/gift/model/common_gift_pop_model.dart';
import 'package:youyu/config/api.dart';

import '../../common/interactor/pop/gift/set/live_pop_gift_index.dart';

enum MicOperationType {
  ///举报
  report,

  ///@
  at,

  ///聊天
  chat,

  ///礼物
  gift,

  /// 上麦
  upMic,

  /// 抱上麦
  hugUpMic,

  /// 锁麦（封麦）
  lockMic,

  /// 解除锁麦（解除封麦）
  unLockMic,

  /// 禁麦
  disableMic,

  /// 解除禁麦
  cancelDisableMic,

  ///下麦（旁听）
  downWheat,

  ///踢出
  kickOut,

  ///禁言
  forbidden,

  ///解除禁言
  cancelForbidden
}

///直播间操作
class LiveIndexOperation {
  //是否礼物弹窗
  var isShowGiftPop = false;

  //是否emoji弹窗
  var isShowEmoji = false;

  final GlobalKey<LivePopUserListState> _popUserListKey =
      GlobalKey<LivePopUserListState>();

  /************** 麦位区域点击 *******************/

  ///麦位操作（start 位 0 和 2 的情况）
  onOperateOnMic(MicSeatState micSeatState) {
    /// 麦位为空
    if (micSeatState.state == 0) {
      _onClickEmptySeatOnWheat(micSeatState);
    }

    /// 锁麦状态
    else if (micSeatState.state == 2) {
      _onClickLuckSeat(micSeatState);
    }
  }

  ///点击空麦位上麦操作
  _onClickEmptySeatOnWheat(MicSeatState micSeatState) {
    /// 房主操作
    if (LiveIndexLogic.to.isOwner) {
      if (micSeatState.position == 0) {
        if ((LiveIndexLogic.to.onSeatCheckIsOnMic(UserController.to.id))) {
          ToastUtils.show('您已经在麦上');
          return;
        }
        TRTCService().sendOnWheatChange(
            position: micSeatState.position,
            state: 1,
            mute: micSeatState.mute,
            userId: UserController.to.id);
      } else {
        onSeatByOwnerOrManagerMoreAction(micSeatState, false);
      }
    }

    /// 管理员操作
    else if (LiveIndexLogic.to.isManager) {
      if (micSeatState.position == 0) {
        if ((LiveIndexLogic.to.onSeatCheckIsOnMic(UserController.to.id))) {
          ToastUtils.show('已经在麦上');
          return;
        }
        TRTCService().sendOnWheatChange(
            position: micSeatState.position,
            state: 1,
            mute: micSeatState.mute,
            userId: UserController.to.id);
      } else {
        onSeatByOwnerOrManagerMoreAction(micSeatState, false);
      }
    } else {
      /// 其他听众操作
      if (micSeatState.position == 0) {
        ToastUtils.show("此位置需要房主或管理员身份");
        return;
      } else {
        TRTCService().sendOnWheatChange(
            position: micSeatState.position,
            state: 1,
            mute: micSeatState.mute,
            userId: UserController.to.id);
      }
    }
  }

  ///点击锁麦的操作
  _onClickLuckSeat(MicSeatState micSeatState) {
    /// 房主操作
    if (LiveIndexLogic.to.isOwner) {
      onSeatByOwnerOrManagerMoreAction(micSeatState, true);
    }

    /// 管理员
    else if (LiveIndexLogic.to.isManager) {
      onSeatByOwnerOrManagerMoreAction(micSeatState, true);
    }

    /// 其他听众
    else {
      ToastUtils.show('麦位已锁');
      return;
    }
  }

  ///麦位点击操作
  onOpenMicOperationSheet({bool isManager = false, bool showCharm = true}) {}

  /************** 顶部区域点击 *******************/

  ///用户列表
  onOperateUserList({int position = -1}) {
    Get.bottomSheet(LivePopUserList(
      key: _popUserListKey,
      roomId: LiveIndexLogic.to.roomId,
      position: position,
      isOwner: LiveIndexLogic.to.isOwner,
      onClickThreeListMore: onSeatUserListMoreAction,
      onlineUserList: LiveIndexLogic.to.viewObs.onlineUserList,
      isManager: LiveIndexLogic.to.isManager,
    ));
  }

  ///更多
  onOperateTopMore() {
    Get.dialog(LivePopClose(
      onPackUpRoom: onOperateOpenFloatWindow,
      onReportRoom: () {
        Get.toNamed(AppRouter().otherPages.reportRoute.name, arguments: {
          'type': ReportType.room,
          'id': LiveIndexLogic.to.roomInfoObs.value?.id
        });
      },
      onLeaveRoom: onOperateLeave,
    ));
  }

  ///收起
  onOperateOpenFloatWindow() {
    LiveService().isInLive = false;
    LiveService().isShowGlobalCard.value = true;
    Get.back();
  }

  ///离开
  onOperateLeave() async {
    LiveService().isInLive = false;
    // if (TRTCService().isUpMic.value) {
    //   await onOperateDownMicTap();
    // }
    await TRTCService().leaveRoom();
    Get.back();
  }

  ///关注直播间
  onOperateFocusLive() {
    LiveIndexLogic.to.showCommit();
    LiveIndexLogic.to.request(AppApi.liveFocusUrl,
        params: {'room_id': LiveIndexLogic.to.roomId}).then((value) {
      LiveIndexLogic.to.viewObs.isFocusLive.value = value.data['is_follow'];
    });
  }

  ///点击公告
  onOperateNotice(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    Size size = renderBox.paintBounds.size;
    Get.dialog(LivePopNotice(
      offset: offset,
      size: size,
      notice: LiveIndexLogic.to.viewObs.notice.value,
    ));
  }

  /************** 公共事件点击 *******************/

  ///主持设置
  onOperateCompere() {
    showModalBottomSheet(
        context: Get.context!,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return LiveCompereWidget(
            roomId: LiveIndexLogic.to.roomId,
            settingNotify: LiveIndexLogic.to.notification!.settingNotify,
          );
        },
        isScrollControlled: true);
  }

  ///连麦弹窗
  onOperateLink() {
    if (LiveIndexLogic.to.isOwner) {
      Get.bottomSheet(LiveLinkOwnerList(
        key: _popUserListKey,
        roomId: LiveIndexLogic.to.roomId,
        onlineUserList: LiveIndexLogic.to.viewObs.onlineUserList,
      ));
    } else {
      //TODO:test
      Get.bottomSheet(LiveLinkUser(
        key: _popUserListKey,
        roomId: LiveIndexLogic.to.roomId,
      ));
    }
  }

  ///头条弹窗
  onOperateHeadline() {
    Get.bottomSheet(LivePopWorldMsg(
      roomId: LiveIndexLogic.to.roomId,
    ));
  }

  ///发送世界消息
  Future<bool> onOperateSendWorldMsg(String msg) async {
    try {
      final response =
          await LiveIndexLogic.to.request(AppApi.liveSendWorldMsgUrl, params: {
        'message': msg,
        'user_id': UserController.to.id,
      });

      if (response.code == 1) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error sending world message: $e');
      return false;
    }
  }

  ///邂逅关系弹窗
  onOperateRelation() {
    if (LiveIndexLogic.to.onSeatMics()[0].user!.id == UserController.to.id) {
      Get.bottomSheet(LivePopRelation(userPair: LiveIndexLogic.to.onSeatMics()))
          .then((value) {
        print('关闭了关系弹窗,默认无关系');
        LiveIndexLogic.to.operation.onOperateRelationConfirm(0);
      });
    }
  }

  ///邂逅关系确认
  onOperateRelationConfirm(relationId) {
    LiveIndexLogic.to
        .request(AppApi.liveFriendSetRelationUrl, isShowToast: true, params: {
      'room_id': LiveIndexLogic.to.roomId,
      'friends_id': LiveIndexLogic.to.friendStateObs.value?.id,
      'relation_id': relationId
    }).then((value) {
      //在有效的关系id发送成功后退出弹窗
      if (value.code == 1 && relationId != 0) {
        Get.back();
      }
    });
  }

  ///酒吧设置礼物弹窗
  onOperateBarGift() {
    Get.bottomSheet(const LivePopGift()).then((value) {});
  }

  onOperateBarGiveGift({userlist, gift}) {
    Get.bottomSheet(LivePopGiveGift(
      gift: gift,
      userlist: userlist,
    )).then((value) {});
  }

  //酒吧礼物设置
  onOperateBarGiftSet(giftId) {
    LiveIndexLogic.to.request(AppApi.LiveBarSetGift,
        isShowToast: true,
        params: {
          'room_id': LiveIndexLogic.to.roomId,
          'gift_id': giftId
        }).then((value) {
      if (value.code == 1) Get.back();
    });
  }

  ///公屏item事件
  onOperateScreenItem(LiveMessageModel model) {
    UserInfo? targetUserInfo;
    if (model.type == LiveMessageType.manager) {
      targetUserInfo = (model.data as LiveManagerMsg).userInfo;
    } else {
      targetUserInfo = model.userInfo;
    }
    if (targetUserInfo?.id != null) {
      ///判断是否在麦位上
      int position = -1;
      for (MicSeatState micSeatState in LiveIndexLogic.to.onSeatMics()) {
        if (micSeatState.user?.id == targetUserInfo?.id) {
          position = micSeatState.position;
          break;
        }
      }
      onOperateShowUserCard(targetUserInfo, position: position);
    }
  }

  ///用户卡片
  onOperateShowUserCard(UserInfo? targetUserInfo, {int position = -1}) async {
    List<int> onWheatUserIds = (LiveIndexLogic.to.onSeatMicUsers())
        .map((e) => e.user.id ?? 0)
        .toList();

    ///是否禁麦
    bool isDisableMic =
        LiveIndexLogic.to.onSeatCheckIsDisableMic(targetUserInfo?.id ?? 0);

    //用户弹窗
    MicOperationType? eventType = await Get.bottomSheet(
        LivePopUser(
          roomId: LiveIndexLogic.to.roomId,
          targetUserId: targetUserInfo?.id ?? 0,
          targetUserInfo: targetUserInfo,
          isOwnerByOp: LiveIndexLogic.to.isOwner,
          isManagerByOp: LiveIndexLogic.to.isManager,
          isManagerByTarget:
              LiveIndexLogic.to.onManagerById(targetUserInfo?.id ?? 0),
          isOwnerByTarget: targetUserInfo?.id == LiveIndexLogic.to.ownerId,
          isOnWheatByTarget: onWheatUserIds.contains(targetUserInfo?.id ?? 0),
          isDisableMic: isDisableMic,
          updateTargetInfo: (UserInfo? targetInfo) {
            targetUserInfo = targetInfo;
          },
        ),
        isScrollControlled: true);

    if (eventType != null) {
      int targetUserId = targetUserInfo?.id ?? 0;
      switch (eventType) {
        case MicOperationType.report:

          ///举报个人
          Get.toNamed(AppRouter().otherPages.reportRoute.name, arguments: {
            'type': ReportType.user,
            'id': targetUserId.toString()
          });
          break;
        case MicOperationType.at:

          ///@人
          onOperateInput(isAt: true, targetUserInfo: targetUserInfo);
          break;
        case MicOperationType.chat:

          ///直接聊天
          onOperateMsgDetail(targetUserId, targetUserInfo?.nickname ?? "",
              (RoomListItem? item) {
            Get.back();
            LiveService()
                .pushToLive(item?.id, item?.groupId, isChangeRoom: true);
          }, isShowDirect: true);
          break;
        case MicOperationType.gift:

          ///直播礼物
          if (targetUserInfo != null) {
            onOperateGift(
                [GiftUserPositionInfo(position: 0, user: targetUserInfo!)],
                isSeatUsers: false);
          }

          break;

        case MicOperationType.downWheat: //旁听
          if (position > -1) {
            //下麦
            TRTCService()
                .sendOnWheatChange(position: position, state: 0, userId: -1);
          }

          break;
        case MicOperationType.forbidden: //禁言
        case MicOperationType.cancelForbidden: //解除禁言
          if (targetUserInfo != null) {
            onOperateForbidTime(targetUserInfo!, 1,
                isRelieve: eventType == MicOperationType.cancelForbidden);
          }

          break;
        case MicOperationType.kickOut: //踢出
          if (targetUserInfo != null) {
            onOperateForbidTime(targetUserInfo!, 2);
          }

          break;
        case MicOperationType.disableMic: //禁麦
          MicSeatState micSeatState = (LiveIndexLogic.to.onSeatMics())
              .firstWhere((element) => element.position == position);
          TRTCService().sendOnMuteChange(
              position: micSeatState.position,
              state: micSeatState.state,
              mute: 1,
              userId: micSeatState.user?.id ?? -1);
          break;
        case MicOperationType.cancelDisableMic: //解除禁麦
          MicSeatState micSeatState = (LiveIndexLogic.to.onSeatMics())
              .firstWhere((element) => element.position == position);
          TRTCService().sendOnMuteChange(
              position: micSeatState.position,
              state: micSeatState.state,
              mute: 0,
              userId: micSeatState.user?.id ?? -1);
          break;
        case MicOperationType.lockMic: //封麦
          MicSeatState micSeatState = (LiveIndexLogic.to.onSeatMics())
              .firstWhere((element) => element.position == position);
          TRTCService().sendOnWheatChange(
              position: micSeatState.position,
              state: 2,
              mute: micSeatState.mute,
              userId: -1);
          break;
        default:
          break;
      }
    }
  }

  ///麦位弹窗操作
  //用户列表操作更多
  onSeatUserListMoreAction(int position, UserInfo userInfo) {
    AppActionSheet().showSheet(
        theme: AppWidgetTheme.dark,
        actions: ["抱上麦", userInfo.isMuted == 1 ? "解除禁言" : "禁言", "踢出"],
        onClick: (index) {
          switch (index) {
            case 0:
              LiveIndexLogic.to.notification?.sendMsg
                  .sendHugUpMicMsg(position, userInfo);
              break;
            case 1:
              {
                onOperateForbidTime(userInfo, 1,
                    isRelieve: userInfo.isMuted == 1);
              }
              break;
            case 2:
              onOperateForbidTime(userInfo, 2);
              break;
          }
        });
  }

  ///禁言/踢出
  onOperateForbidTime(UserInfo userInfo, int type, {bool isRelieve = false}) {
    if (type == 1 && isRelieve) {
      onOperateRequestForbid(userInfo, type, time: 10);
    } else {
      AppActionSheet().showSheet(
          theme: AppWidgetTheme.dark,
          actions: ["十分钟", "三十分钟", "永久"],
          onClick: (index) {
            switch (index) {
              case 0:
                onOperateRequestForbid(userInfo, type, time: 10);
                break;
              case 1:
                onOperateRequestForbid(userInfo, type, time: 30);
                break;
              case 2:
                onOperateRequestForbid(userInfo, type, time: -1);
                break;
            }
          });
    }
  }

  onOperateRequestForbid(UserInfo userInfo, int type, {int? time}) {
    LiveIndexLogic.to.showCommit();
    Map<String, dynamic> params = {
      'room_id': LiveIndexLogic.to.roomId,
      'type': type,
      'user_id': userInfo.id,
    };
    if (time != null) {
      params['time'] = time;
    }
    LiveIndexLogic.to
        .request(AppApi.setRoomForbidUrl, params: params)
        .then((value) {
      if (type == 1) {
        if (userInfo.isMuted == 1) {
          userInfo.isMuted = 0;
        } else {
          userInfo.isMuted = 1;
        }
        LiveIndexLogic.to.notification?.sendMsg.sendForbiddenMsg(userInfo);
      } else {
        LiveIndexLogic.to.notification?.sendMsg.sendKitOutMsg(userInfo);
      }
      _popUserListKey.currentState?.updateForbidUserInfo(type, userInfo);
    });
  }

  //房主管理员操作
  onSeatByOwnerOrManagerMoreAction(
      MicSeatState micSeatState, bool isLockState) {
    AppExtActionSheet().showSheet(
        theme: AppWidgetTheme.dark,
        actions: [
          ItemTitleModel(type: MicOperationType.upMic, title: "上麦"),
          ItemTitleModel(type: MicOperationType.hugUpMic, title: "抱TA上麦"),
          ItemTitleModel(
              type: micSeatState.mute == 1
                  ? MicOperationType.cancelDisableMic
                  : MicOperationType.disableMic,
              title: micSeatState.mute == 1 ? "解除禁麦" : "禁麦"),
          ItemTitleModel(
              type: isLockState
                  ? MicOperationType.unLockMic
                  : MicOperationType.lockMic,
              title: isLockState ? "解除封麦" : "封麦"),
        ],
        onClick: (model) {
          switch (model.type) {
            case MicOperationType.upMic:
              if ((LiveIndexLogic.to
                  .onSeatCheckIsOnMic(UserController.to.id))) {
                ToastUtils.show('您已经在麦上！');
                return;
              }
              TRTCService().sendOnWheatChange(
                  position: micSeatState.position,
                  state: 1,
                  mute: micSeatState.mute,
                  userId: UserController.to.id);
              break;
            case MicOperationType.hugUpMic:
              onOperateUserList(position: micSeatState.position);
              break;
            case MicOperationType.lockMic:
              TRTCService().sendOnWheatChange(
                  position: micSeatState.position,
                  state: 2,
                  mute: micSeatState.mute,
                  userId: -1);
              break;
            case MicOperationType.unLockMic:
              TRTCService().sendOnWheatChange(
                  position: micSeatState.position,
                  state: 0,
                  mute: micSeatState.mute,
                  userId: -1);
              break;
            //禁麦
            case MicOperationType.disableMic:
              TRTCService().sendOnMuteChange(
                  position: micSeatState.position,
                  state: micSeatState.state,
                  mute: 1,
                  userId: micSeatState.user?.id ?? -1);
              break;
            case MicOperationType.cancelDisableMic:
              TRTCService().sendOnMuteChange(
                  position: micSeatState.position,
                  state: micSeatState.state,
                  mute: 0,
                  userId: micSeatState.user?.id ?? -1);
              break;
          }
        });
  }

  /************** 游戏相关 *******************/

  onOperateWheelGame(CommonGiftSendModel model) async {
    if (GameService().primaryModel != null &&
        GameService().advancedModel != null) {
      Get.bottomSheet(
        WheelGameViewPage(
          sendModel: model,
          sendMsg: LiveIndexLogic.to.notification!.sendMsg,
        ),
        isScrollControlled: true,
      );
    } else {
      LiveIndexLogic.to.showCommit();
      LiveIndexLogic.to.request(AppApi.wheelGameUrl).then((value) {
        List<dynamic> list = value.data;
        for (Map<String, dynamic> map in list) {
          GiftGame entity = GiftGame.fromJson(map);
          if (entity.name == "初级转盘") {
            GameService().primaryModel = entity;
          } else if (entity.name == "高级转盘") {
            GameService().advancedModel = entity;
          }
        }
        Get.bottomSheet(
          WheelGameViewPage(
              sendModel: model,
              sendMsg: LiveIndexLogic.to.notification!.sendMsg),
          isScrollControlled: true,
        );
      });
    }
  }

  /************** 底部区域点击 *******************/

  ///静音
  onOperateVolume() {
    if (TRTCService().isCloseVolume.value) {
      TRTCService().openVolume();
    } else {
      TRTCService().closeVolume();
    }
  }

  ///闭麦
  onOperateCloseMic() {
    // ToastUtils.show("点击了闭麦");
    TRTCService().closeMic();
  }

  ///开麦
  onOperateOpenMic() {
    if ((LiveIndexLogic.to.onSeatCheckIsDisableMic(UserController.to.id))) {
      ToastUtils.show("您已被禁麦");
    } else {
      TRTCService().openMic();
    }
  }

  ///上麦
  onOperateUpMicTap() {
    LiveIndexLogic.to.onSeatUnMic();
  }

  ///下麦
  onOperateDownMicTap() async {
    await LiveIndexLogic.to.onSeatDownMic();
  }

  ///礼物弹窗
  onOperateGift(List<GiftUserPositionInfo> userList,
      {bool isSeatUsers = true, bool isSupportGift = false}) async {
    if (isShowGiftPop) {
      return;
    }
    isShowGiftPop = true;
    LiveIndexLogic.to.viewObs.giftSlideTop.value =
        LiveIndexLogic.to.viewObs.giftNormalSlideTop - 160.h;
    //解决键盘问题
    await showModalBottomSheet(
        context: Get.context!,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) {
          return CommonGiftPopPage(
            isShowUserList: true,
            giftUserList: userList,
            roomId: LiveIndexLogic.to.roomInfoObs.value?.id,
            isSeatUsers: isSeatUsers,
            onSend: (CommonGiftSendModel? model) {
              isShowGiftPop = false;
              LiveIndexLogic.to.notification?.sendMsg
                  .sendGift(model, isSupportGift);
            },
            //点击游戏
            onGame: (CommonGiftSendModel model) {
              Get.back();
              Future.delayed(const Duration(milliseconds: 10), () {
                switch (model.gift.id) {
                  case AppConfig.gameWheelId:
                    onOperateWheelGame(model);
                    break;
                }
              });
            },
          );
        });
    isShowGiftPop = false;
    LiveIndexLogic.to.viewObs.giftSlideTop.value =
        LiveIndexLogic.to.viewObs.giftNormalSlideTop;
  }

  ///底部更多
  onOperateBottomMore() async {
    MenuModel? model = await Get.bottomSheet(LivePopBottomMore(
      isOwner: LiveIndexLogic.to.isOwner,
      isManager: LiveIndexLogic.to.isManager,
      isCloseAni: LiveIndexLogic.to.isCloseAni.value,
      isCloseScreen: LiveIndexLogic.to.isCloseScreen.value,
    ));
    if (model != null) {
      switch (model.type as LivePopBottomMoreType) {
        case LivePopBottomMoreType.share:

          ///分享
          Get.bottomSheet(LivePopShare());
          break;
        case LivePopBottomMoreType.setting:

          ///设置
          Get.toNamed(AppRouter().livePages.liveSettingRoute.name, arguments: {
            'roomInfo': LiveIndexLogic.to.roomInfoObs.value,
            'settingNotify': LiveIndexLogic.to.notification?.settingNotify,
            'isOwner': LiveIndexLogic.to.isOwner
          });
          break;
        case LivePopBottomMoreType.clearScreen:

          ///清屏
          LiveIndexLogic.to.notification?.screenNotify.clearScreen();
          break;
        case LivePopBottomMoreType.closeAni:

          ///关闭动效
          if (LiveIndexLogic.to.isCloseAni.value) {
            LiveIndexLogic.to.isCloseAni.value = false;
          } else {
            LiveIndexLogic.to.isCloseAni.value = true;
            LiveIndexLogic.to.notification?.giftSlideNotify.clearBigAniQue();
          }
          break;
        case LivePopBottomMoreType.closeScreen:
          {
            ///关闭公屏
            LiveIndexLogic.to.showCommit();
            LiveIndexLogic.to.request(AppApi.roomUpSpeakUrl,
                params: {'room_id': LiveIndexLogic.to.roomId}).then((value) {
              bool isCloseScreen = LiveIndexLogic.to.isCloseScreen.value;
              LiveIndexLogic.to.isCloseScreen.value = !isCloseScreen;
            });
          }
          break;
        case LivePopBottomMoreType.clearML:
          {
            onOperateClearCharm();
          }
          break;
        case LivePopBottomMoreType.zc:
          {
            onOperateCompere();
          }
          break;
        default:
          break;
      }
    }
  }

  ///清空魅力值
  onOperateClearCharm() async {
    List<UserInfo> users = [];
    for (MicSeatState state in LiveIndexLogic.to.onSeatMics()) {
      if (state.user != null) {
        users.add(state.user!);
      } else {
        users.add(UserInfo(id: -1));
      }
    }
    List<UserInfo>? selUser = await Get.bottomSheet(LiveClearCharmSheet(
      users: users,
    ));
    if (selUser?.isNotEmpty == true) {
      LiveIndexLogic.to.showCommit();
      LiveIndexLogic.to.request(AppApi.liveClearRoomCharmUrl, params: {
        'user_ids': (selUser?.map((e) => e.id).toList())?.join(','),
        'room_id': LiveIndexLogic.to.roomId
      }).then((value) {
        ToastUtils.show("清除成功");
      });
    }
  }

  ///直播间聊天im
  onOperateConversation() {
    showModalBottomSheet(
        context: Get.context!,
        backgroundColor: Colors.transparent,
        builder: (s) {
          return LiveConversationPage(
            height: ScreenUtils.screenHeight -
                ScreenUtils.navbarHeight -
                ScreenUtils.statusBarHeight -
                120.h,
            onClickConversation: (V2TimConversation conversation) {
              onOperateMsgDetail(
                  FormatUtil.getRealId(conversation.userID ?? '0'),
                  conversation.showName ?? "", (RoomListItem? item) {
                Get.back();
                LiveService()
                    .pushToLive(item?.id, item?.groupId, isChangeRoom: true);
              });
            },
          );
        },
        isScrollControlled: true);
  }

  ///聊天会话详情
  onOperateMsgDetail(int userId, String userName,
      Function(RoomListItem? item) onChangeLiveRoom,
      {bool isShowDirect = false}) {
    showModalBottomSheet(
        context: Get.context!,
        backgroundColor: Colors.transparent,
        builder: (s) {
          return LiveMessageDetailPage(
            height: ScreenUtils.screenHeight -
                ScreenUtils.navbarHeight -
                ScreenUtils.statusBarHeight -
                120.h,
            userId: userId,
            userName: userName,
            onChangeLiveRoom: (RoomListItem? item) {
              if (item?.id != LiveIndexLogic.to.roomId) {
                Get.back();
                onChangeLiveRoom(item);
              } else {
                ToastUtils.show("您已经在Ta的房间");
              }
            },
            isShowDirect: isShowDirect,
          );
        },
        isScrollControlled: true);
  }

  ///输入框
  onOperateInput({bool isAt = false, UserInfo? targetUserInfo}) async {
    if (LiveIndexLogic.to.isMute) {
      ToastUtils.show("您已被禁言");
      return;
    }
    if (LiveIndexLogic.to.isCloseScreen.value) {
      ToastUtils.show("房间已关闭公屏发言");
      return;
    }
    String? text = await Get.bottomSheet(
        LivePopInput(
          isAt: isAt,
          targetUserInfo: targetUserInfo,
        ),
        isScrollControlled: true);

    if (text?.isNotEmpty == true) {
      if (isAt && targetUserInfo != null) {
        String atMsg = "@${targetUserInfo.nickname} ";
        if (text!.startsWith(atMsg) == true) {
          LiveIndexLogic.to.notification?.sendMsg.sendTextAtMessage(
              text.substring(atMsg.length, text.length), targetUserInfo);
        }
      } else {
        LiveIndexLogic.to.notification?.sendMsg.sendTextMessage(text!);
      }
    }
  }

  ///表情弹窗
  onOperateEmoji() async {
    if (LiveIndexLogic.to.isMute) {
      ToastUtils.show("您已被禁言");
      return;
    }
    if (LiveIndexLogic.to.isCloseScreen.value) {
      ToastUtils.show("房间已关闭公屏发言");
      return;
    }
    if (isShowEmoji) {
      return;
    }
    isShowEmoji = true;
    await showModalBottomSheet(
        context: Get.context!,
        backgroundColor: Colors.transparent,
        isScrollControlled: false,
        builder: (context) {
          return AppEmojiWidget(
            isShowCustom: true,
            onEmojiSelected: (Category? category, Emoji emoji) {
              LiveIndexLogic.to.notification?.sendMsg
                  .sendTextMessage(emoji.emoji);
              Get.back();
            },
            onClickGif: (AppCustomEmojiItem item) {
              LiveIndexLogic.to.notification?.sendMsg.onSendGifMessage(item);
              Get.back();
            },
          );
        });
    isShowEmoji = false;
  }

  ///关闭输入相关
  onOperateDismissInputAndEmoji() {
    LiveIndexLogic.to.closeKeyboard();
    if (isShowEmoji) {
      Get.back();
      isShowEmoji = false;
    }
  }

  ///释放
  onClose() {}
}
