import 'dart:async';
import 'dart:convert';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/modules/live/common/message/live_message.dart';
import 'package:youyu/modules/live/common/message/sub/live_announcement_msg.dart';
import 'package:youyu/modules/live/common/message/sub/live_gift_msg.dart';
import 'package:youyu/modules/live/common/message/sub/live_group_at_msg.dart';
import 'package:youyu/modules/live/common/message/sub/live_join_msg.dart';
import 'package:youyu/modules/live/common/message/sub/live_leave_msg.dart';
import 'package:youyu/modules/live/common/message/sub/live_manager_msg.dart';
import 'package:youyu/modules/live/common/message/sub/live_text_msg.dart';
import 'package:youyu/modules/live/common/notification/abs/live_notification.dart';
import 'package:youyu/modules/live/common/widget/screen/live_screen_widget.dart';
import 'package:youyu/services/im/model/ext/im_gift_model.dart';
import 'package:youyu/services/im/model/ext/im_group_at_model.dart';
import 'package:youyu/services/im/model/ext/im_live_text_model.dart';
import 'package:youyu/services/im/model/ext/im_manager_model.dart';
import 'package:youyu/services/im/model/im_custom_message_mdoel.dart';
import 'package:youyu/services/im/model/im_msg_type.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:youyu/utils/format_utils.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_group_member_info.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';

///公屏消息
class LiveScreenNotify extends LiveNotificationDispatch {
  Timer? _timer;
  int time = 0;

  ///公屏消息列表
  final GlobalKey<LiveScreenWidgetState> screenKey =
      GlobalKey<LiveScreenWidgetState>();

  ///欢迎语
  insertWelComeMessage(String? message) {
    if (message != null && message.isNotEmpty) {
      LiveMessageModel<LiveAnnounceMentMsg> model = LiveMessageModel(
          isManager: false,
          type: LiveMessageType.announcement,
          data: LiveAnnounceMentMsg(text: message));
      _insertMessage(model);
    }
  }

  ///文字消息
  insertTextMessage(V2TimMessage message, bool isManager) {
    if (message.customElem?.data != null) {
      //转im model
      IMCustomMessageModel<IMLiveTextMsg> imModel =
          IMCustomMessageModel<IMLiveTextMsg>.fromJson(
              IMMsgType.getTypeByType(message.customElem?.desc ?? ""),
              jsonDecode(message.customElem?.data ?? ""));
      //转live model
      LiveMessageModel<LiveTextMsg> model = LiveMessageModel(
          isManager: isManager,
          type: LiveMessageType.text,
          userInfo: imModel.userInfo,
          timestamp: imModel.timestamp,
          data: LiveTextMsg(text: imModel.data?.text ?? ""));

      _insertMessage(model);
    }
  }

  ///@消息
  insertAtTextMessage(V2TimMessage message, bool isManager) {
    if (message.customElem?.data != null) {
      //转im model
      IMCustomMessageModel<IMGroupAtTextMsg> imModel =
          IMCustomMessageModel<IMGroupAtTextMsg>.fromJson(
              IMMsgType.getTypeByType(message.customElem?.desc ?? ""),
              jsonDecode(message.customElem?.data ?? ""));
      //转live model
      LiveMessageModel<LiveGroupAtMsg> model = LiveMessageModel(
          isManager: isManager,
          type: LiveMessageType.groupAt,
          userInfo: imModel.userInfo,
          timestamp: imModel.timestamp,
          data: LiveGroupAtMsg(
              text: imModel.data?.text ?? "",
              atUsers: imModel.data?.atUsers ?? []));
      _insertMessage(model);
    }
  }

  ///礼物消息
  insertGiftMessage(
      IMCustomMessageModel<IMGiftModel> imModel, bool isManager, bool isLuck) {
    //转live model
    LiveMessageModel<LiveGiftMsg> model = LiveMessageModel(
        isManager: isManager,
        type: isLuck ? LiveMessageType.luckGift : LiveMessageType.gift,
        userInfo: imModel.userInfo,
        timestamp: imModel.timestamp,
        data: LiveGiftMsg(
            sender: imModel.userInfo,
            receiver: imModel.data?.receiver,
            gift: imModel.data?.gift));
    _insertMessage(model);
    return model;
  }

  ///进入房间消息
  insertJoinRoomMessage(V2TimMessage message, bool isManager) {
    //转im model
    IMCustomMessageModel<IMLiveTextMsg> imModel =
        IMCustomMessageModel<IMLiveTextMsg>.fromJson(
            IMMsgType.getTypeByType(message.customElem?.desc ?? ""),
            jsonDecode(message.customElem?.data ?? ""));
    //转live model
    LiveMessageModel<LiveJoinMsg> model = LiveMessageModel(
        isManager: isManager,
        type: LiveMessageType.join,
        userInfo: imModel.userInfo,
        timestamp: imModel.timestamp,
        data: LiveJoinMsg());
    screenKey.currentState?.insertMessage(model);
    return model;
  }

  ///设置管理消息
  insertManagerMessage(
      IMCustomMessageModel<IMSyncManagerMsg> imModel, bool isManager) {
    LiveMessageModel<LiveManagerMsg> model = LiveMessageModel(
        isManager: isManager,
        type: LiveMessageType.manager,
        userInfo: imModel.userInfo,
        timestamp: imModel.timestamp,
        data: LiveManagerMsg(imModel.data?.user));
    screenKey.currentState?.insertMessage(model);
  }

  ///离开房间消息
  insertLeaveRoomMessage(V2TimGroupMemberInfo member, bool isManager) {
    //转live model
    LiveMessageModel<LiveLeaveMsg> model = LiveMessageModel(
        isManager: isManager,
        type: LiveMessageType.leave,
        userInfo: UserInfo(
            id: FormatUtil.getRealId(member.userID ?? ""),
            nickname: member.nickName,
            avatar: member.faceUrl),
        timestamp: DateTime.now().millisecondsSinceEpoch,
        data: LiveLeaveMsg());
    screenKey.currentState?.insertMessage(model);
  }

  ///清屏
  clearScreen() {
    screenKey.currentState?.clearAllMessage();
  }

  _insertMessage(LiveMessageModel model) {
    screenKey.currentState?.insertMessage(model);
  }

  ///处理遮罩
  processMaskType(LiveScreenMaskType maskType) {
    screenKey.currentState?.processMaskType(maskType);
  }

  @override
  onClose() {
    _timer?.cancel();
  }
}
