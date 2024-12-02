import 'dart:math';

import 'package:youyu/modules/live/index/live_index_logic.dart';
import 'package:youyu/services/im/model/ext/im_gif_model.dart';
import 'package:youyu/widgets/app/other/emoji/model/app_custom_emoji_item.dart';
import 'package:youyu/widgets/gift/model/common_gift_pop_model.dart';
import 'package:youyu/controllers/gift_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/gift.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/models/room_detail_info.dart';
import 'package:youyu/services/async_down_service.dart';
import 'package:youyu/services/im/model/ext/im_forbidden_model.dart';
import 'package:youyu/services/im/model/ext/im_gift_model.dart';
import 'package:youyu/services/im/model/ext/im_group_at_model.dart';
import 'package:youyu/services/im/model/ext/im_hug_up_mic_model.dart';
import 'package:youyu/services/im/model/ext/im_kick_out_model.dart';
import 'package:youyu/services/im/model/ext/im_live_text_model.dart';
import 'package:youyu/services/im/model/ext/im_manager_model.dart';
import 'package:youyu/services/im/model/ext/im_room_setting_model.dart';
import 'package:youyu/services/im/model/im_custom_message_mdoel.dart';
import 'package:youyu/services/im/model/im_msg_type.dart';
import 'package:youyu/services/im/im_service.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:youyu/services/socket/socket_msg_type.dart';
import 'package:youyu/services/socket/socket_service.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_priority_enum.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';

class LiveIndexSendMsg {
  Function(IMMsgType msgType, V2TimMessage message)? sendMessageSuc;

  ///发送进入房间ws消息
  sendWsJoin() {
    SocketService().sendMessage(
        '{"type": "${SocketMessageType.joinRoom}","room_id": ${LiveIndexLogic.to.roomId}}');
  }

  ///发送文字消息
  sendTextMessage(String text) async {
    IMMsgType imMsgType = IMMsgType.liveRoomText;
    IMCustomMessageModel<IMLiveTextMsg> model = IMCustomMessageModel(
        userInfo: UserController.imUserInfo(),
        data: IMLiveTextMsg(text: text),
        timestamp: DateTime.now().millisecondsSinceEpoch);
    try {
      var msg = await IMService().sendGroupCustomMsg(
        model,
        imMsgType.type,
        groupID: LiveIndexLogic.to.imGroupId,
      );
      if (sendMessageSuc != null && msg.data != null) {
        sendMessageSuc!(imMsgType, msg.data!);
      }
    } catch (e) {
      print(e);
    }
  }

  ///发送gif消息
  onSendGifMessage(AppCustomEmojiItem item) async {
    IMMsgType imMsgType = IMMsgType.gif;

    String gifName = item.name;
    if (item.isRandom) {
      Random random = Random();
      int randomIndex = random.nextInt(item.emojis?.length ?? 0);
      String randomData = item.emojis![randomIndex];
      gifName = randomData;
    }

    IMGifModel gifModel = IMGifModel(name: gifName, isShowEnd: item.isShowEnd);
    IMCustomMessageModel<IMGifModel> model = IMCustomMessageModel(
        userInfo: UserController.imUserInfo(),
        data: gifModel,
        timestamp: DateTime.now().millisecondsSinceEpoch);
    try {
      var msg = await IMService().sendGroupCustomMsg(
        model,
        imMsgType.type,
        groupID: LiveIndexLogic.to.imGroupId,
      );
      if (sendMessageSuc != null && msg.data != null) {
        sendMessageSuc!(imMsgType, msg.data!);
      }
    } catch (e) {
      //...
    }
  }

  ///发送@文字消息
  sendTextAtMessage(String text, UserInfo targetUserInfo) async {
    IMMsgType imMsgType = IMMsgType.groupAt;
    IMCustomMessageModel<IMGroupAtTextMsg> model = IMCustomMessageModel(
        userInfo: UserController.imUserInfo(),
        data: IMGroupAtTextMsg(text: text, atUsers: [targetUserInfo]),
        timestamp: DateTime.now().millisecondsSinceEpoch);
    try {
      var msg = await IMService().sendGroupCustomMsg(
        model,
        imMsgType.type,
        groupID: LiveIndexLogic.to.imGroupId,
      );
      if (sendMessageSuc != null && msg.data != null) {
        sendMessageSuc!(imMsgType, msg.data!);
      }
    } catch (e) {
      //...
    }
  }

  ///进入房间消息
  sendJoinMessage() async {
    IMMsgType imMsgType = IMMsgType.joinRoom;
    IMCustomMessageModel<IMLiveTextMsg> model = IMCustomMessageModel(
        userInfo: UserController.imUserInfo(),
        data: IMLiveTextMsg(text: ''),
        timestamp: DateTime.now().millisecondsSinceEpoch);
    try {
      var msg = await IMService().sendGroupCustomMsg(model, imMsgType.type,
          groupID: LiveIndexLogic.to.imGroupId,
          priority: MessagePriorityEnum.V2TIM_PRIORITY_LOW);
      if (sendMessageSuc != null && msg.data != null) {
        sendMessageSuc!(imMsgType, msg.data!);
      }
    } catch (e) {
      //...
    }

    //如果用户装饰了座驾,发送座驾动画
    // if (UserController.to.userInfo.value?.dressCar()?.res?.isNotEmpty == true) {
    //   IMMsgType imMsgType = IMMsgType.joinRoomWithDressCar;
    //   await IMService().sendGroupCustomMsg(
    //       IMCustomMessageModel(userInfo: UserController.to.userInfo.value),
    //       imMsgType.type,
    //       groupID: LiveIndexLogic.to.imGroupId);
    //   // if (!LiveIndexLogic.to.isCloseAni.value) {
    //   //   AsyncDownService().addTask(
    //   //       DownType.bigGifAni,
    //   //       DownModel(
    //   //           url: '${UserController.to.userInfo.value?.dressCar()?.res}'));
    //   // }
    // }
  }

  /// 送礼物
  sendGift(CommonGiftSendModel? sendModel, bool isSupportGift,
      {Function(IMCustomMessageModel<IMGiftModel>? model)? callBack}) async {
    if (sendModel?.giftTypeId == GiftController.ftId) {
      ///福袋礼物
      IMMsgType imMsgType = IMMsgType.luckyGift;
      GiftController.to.liveSendLuckyGift(sendModel,
          (IMCustomMessageModel<IMGiftModel> model, bool isLast) async {
        var msg = await IMService().sendGroupCustomMsg(model, imMsgType.type,
            groupID: LiveIndexLogic.to.imGroupId,
            priority: MessagePriorityEnum.V2TIM_PRIORITY_HIGH);
        if (sendMessageSuc != null && msg.data != null) {
          sendMessageSuc!(imMsgType, msg.data!);
        }
        if (callBack != null) {
          callBack(model);
        }
        if (isLast) {
          //播放礼物动效
          List<Gift> subList = model.data?.gift?.childList ?? [];
          for (Gift gift in subList) {
            if (gift.playSvg == 1) {
              if (!LiveIndexLogic.to.isCloseAni.value) {
                AsyncDownService().addTask(
                    DownType.bigGifAni, DownModel(url: (gift.svg ?? "")));
              }
            }
          }
        }
      }, isSupportGift, () {
        //error
            if (callBack != null) {
              callBack(null);
            }
          });
    } else {
      ///普通礼物
      IMMsgType imMsgType = IMMsgType.gift;
      GiftController.to.liveSendNormalGift(sendModel,
          (IMCustomMessageModel<IMGiftModel> model, bool isLast) async {
        var msg = await IMService().sendGroupCustomMsg(
          model,
          imMsgType.type,
          groupID: LiveIndexLogic.to.imGroupId,
          priority: MessagePriorityEnum.V2TIM_PRIORITY_HIGH,
        );
        if (sendMessageSuc != null && msg.data != null) {
          sendMessageSuc!(imMsgType, msg.data!);
        }
      }, isSupportGift);
    }
  }

  ///同步房间设置消息
  sendRoomSettingMessage(
      LiveSettingType settingType, RoomDetailInfo roomDetailInfo) async {
    IMMsgType imMsgType = IMMsgType.roomSetting;
    IMCustomMessageModel<IMRoomSettingMsg> model = IMCustomMessageModel(
        userInfo: UserController.imUserInfo(),
        data: IMRoomSettingMsg(
            settingType: settingType, roomInfo: roomDetailInfo),
        timestamp: DateTime.now().millisecondsSinceEpoch);
    try {
      await IMService().sendGroupCustomMsg(model, imMsgType.type,
          groupID: LiveIndexLogic.to.imGroupId,
          priority: MessagePriorityEnum.V2TIM_PRIORITY_HIGH);
    } catch (e) {
      //...
    }
  }

  ///管理员消息
  sendManagerMsg(int status, UserInfo user) async {
    IMMsgType imMsgType = IMMsgType.manager;
    IMCustomMessageModel<IMSyncManagerMsg> model = IMCustomMessageModel(
        userInfo: UserController.imUserInfo(),
        data: IMSyncManagerMsg(status: status, user: user),
        timestamp: DateTime.now().millisecondsSinceEpoch);
    try {
      var msg = await IMService().sendGroupCustomMsg(model, imMsgType.type,
          groupID: LiveIndexLogic.to.imGroupId,
          priority: MessagePriorityEnum.V2TIM_PRIORITY_HIGH);
      if (sendMessageSuc != null && msg.data != null) {
        sendMessageSuc!(imMsgType, msg.data!);
      }
    } catch (e) {
      //...
    }
  }

  /// 抱上麦
  sendHugUpMicMsg(int position, UserInfo userInfo) async {
    IMMsgType imMsgType = IMMsgType.hugUpMicMsg;
    IMCustomMessageModel<IMHugUpMicMsg> model = IMCustomMessageModel(
        userInfo: UserController.imUserInfo(),
        data: IMHugUpMicMsg(position: position, userInfo: userInfo),
        timestamp: DateTime.now().millisecondsSinceEpoch);
    try {
      await IMService().sendGroupCustomMsg(model, imMsgType.type,
          groupID: LiveIndexLogic.to.imGroupId,
          priority: MessagePriorityEnum.V2TIM_PRIORITY_HIGH);
    } catch (e) {
      //...
    }
  }

  ///禁言
  sendForbiddenMsg(UserInfo userInfo) async {
    IMMsgType imMsgType = IMMsgType.forbidden;
    IMCustomMessageModel<IMForbiddenMsg> model = IMCustomMessageModel(
        userInfo: UserController.imUserInfo(),
        data: IMForbiddenMsg(userInfo: userInfo),
        timestamp: DateTime.now().millisecondsSinceEpoch);
    try {
      await IMService().sendGroupCustomMsg(model, imMsgType.type,
          groupID: LiveIndexLogic.to.imGroupId,
          priority: MessagePriorityEnum.V2TIM_PRIORITY_HIGH);
    } catch (e) {
      //...
    }
  }

  ///踢出群
  sendKitOutMsg(UserInfo userInfo) async {
    IMMsgType imMsgType = IMMsgType.kickOut;
    IMCustomMessageModel<IMKickOutMsg> model = IMCustomMessageModel(
        userInfo: UserController.imUserInfo(),
        data: IMKickOutMsg(userInfo: userInfo),
        timestamp: DateTime.now().millisecondsSinceEpoch);
    try {
      await IMService().sendGroupCustomMsg(model, imMsgType.type,
          groupID: LiveIndexLogic.to.imGroupId,
          priority: MessagePriorityEnum.V2TIM_PRIORITY_HIGH);
    } catch (e) {
      //...
    }
  }
}
