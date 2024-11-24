import 'dart:convert';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/controllers/app_controller.dart';
import 'package:youyu/controllers/auth_controller.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/router/router.dart';
import 'package:youyu/services/im/im_listener.dart';
import 'package:youyu/services/im/im_service.dart';
import 'package:youyu/services/im/model/im_msg_type.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/utils/format_utils.dart';
import 'package:youyu/widgets/app/dialog/app_tip_dialog.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_sdk/enum/message_elem_type.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_conversation.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'base/base_controller.dart';
import 'package:youyu/config/api.dart';

mixin ConversationRefreshListener {
  void onDataRefresh(bool isRefreshCompleted);
}

///会话管理
class ConversationController extends AppBaseController
    with IMConversationListener {
  static ConversationController get to => Get.find<ConversationController>();

  ///数据
  List<V2TimConversation> dataList = [];
  List<String> conversationIds = [];

  ///监听
  List<ConversationRefreshListener> observers = [];

  initConversationManager() {
    IMService().addImConversationListener(this);
  }

  addObserver(ConversationRefreshListener listener) {
    observers.add(listener);
  }

  removeObserver(ConversationRefreshListener listener) {
    observers.remove(listener);
  }

  ///获取数据
  fetchList() {
    IMService().getC2CConversations().then((value) {
      progressData(value);
    });
  }

  ///数据处理
  progressData(List<V2TimConversation> value) {
    value.sort((c1, c2) => (c2.lastMessage?.timestamp ?? 0)
        .compareTo(c1.lastMessage?.timestamp ?? 0));
    //记录数据
    dataList.clear();
    dataList.addAll(
        value.where((element) => element.userID != IMService.adminId).toList());
    //记录id
    conversationIds.clear();
    conversationIds.addAll(value.map((e) => e.conversationID).toList());
    // if (conversationIds.isEmpty) {
    //   setEmptyType(message: "暂无聊天会话");
    // } else {
    //   setSuccessType();
    // }
    for (ConversationRefreshListener listener in observers) {
      listener.onDataRefresh(true);
    }

    _fetchStateData();
  }

  ///获取状态信息
  _fetchStateData() {
    //copy原数据
    List<V2TimConversation> tempList = [];
    tempList.addAll(dataList);
    //转map
    Map<String, V2TimConversation> tempMap = {};
    for (V2TimConversation conversation in dataList) {
      if (conversation.groupID == null) {
        tempMap[FormatUtil.getRealIdByConId(conversation.conversationID)
            .toString()] = conversation;
      }
    }
    request(AppApi.msgConversationUrl, isShowToast: false)
        .then((value) {
      List<dynamic> list = value.data;
      for (int i = 0; i < list.length; i++) {
        Map<String, dynamic> map = list[i];
        var userData = map['user_data'];
        V2TimConversation? conversation = tempMap[userData['id'].toString()];
        if (conversation != null) {
          conversation.customData = jsonEncode(map['user_data']);
        }
      }
      for (ConversationRefreshListener listener in observers) {
        listener.onDataRefresh(false);
      }
    });
  }

  ///显示文字
  String displayText({V2TimMessage? msg}) {
    String defaultMsg = '[ 消息 ]';
    // https://comm.qq.com/im/doc/flutter/api/v2timmessagemanager/addadvancedmsglistener.html
    switch (msg?.elemType) {
      case MessageElemType.V2TIM_ELEM_TYPE_TEXT:
        return msg?.textElem?.text ?? defaultMsg;
      case MessageElemType.V2TIM_ELEM_TYPE_IMAGE:
        return '[ 图片 ]';
      case MessageElemType.V2TIM_ELEM_TYPE_SOUND:
        return '[ 语音 ]';
      case MessageElemType.V2TIM_ELEM_TYPE_CUSTOM:
        if (msg?.customElem?.desc == IMMsgType.gift.type) {
          return '[ 礼物 ]';
        } if (msg?.customElem?.desc == IMMsgType.gif.type) {
          return '[ 表情 ]';
        } else {
          return defaultMsg;
        }
      default:
        return defaultMsg;
    }
  }

  ///删除会话
  delConversation(int idx) async {
    showCommit();
    await IMService().deleteConversation(conversationIds[idx]);
    dataList.removeAt(idx);
    conversationIds.removeAt(idx);
    hiddenCommit();
    for (ConversationRefreshListener listener in observers) {
      listener.onDataRefresh(false);
    }
  }

  ///进入会话   slideController?.close(duration: const Duration(milliseconds: 100));
  onClickConversation(V2TimConversation conversation) {
    IMService().pushToMessageDetail(
        userId: FormatUtil.getRealId(conversation.userID ?? '0'),
        userName: conversation.showName ?? "");
  }

  ///进入自定义会话
  onClickCustomConversation(IMMsgType msgType) {
    Get.toNamed(AppRouter().messagePages.messageNotificationRoute.name,
            arguments: msgType)
        ?.then((value) {
      //先更新本地
      if (msgType == IMMsgType.officialSystem) {
        AppController.to.sysUnReadCount.value = 0;
      } else {
        AppController.to.noticeUnReadCount.value = 0;
      }
      //再同步服务端数量
      AppController.to.requestSysNoticeUnReadCount();
    });
  }

  ///进入直播间
  pushToLive(UserInfo? userInfo) {
    LiveService().pushToLive(
        userInfo?.thisRoomInfo?.id, userInfo?.thisRoomInfo?.groupId);
  }

  ///会话变化监听
  @override
  onConversationChanged(List<V2TimConversation> conversationList) {
    //追加的数据
    if (AuthController.to.isLogin) {
      List<V2TimConversation> insertList = [];
      for (V2TimConversation temp in conversationList) {
        if (conversationIds.contains(temp.conversationID)) {
          //替换最新的
          int index = conversationIds.indexOf(temp.conversationID);
          V2TimConversation oldConversation = dataList[index];
          temp.customData = oldConversation.customData;
          dataList.replaceRange(index, index + 1, [temp]);
        } else {
          insertList.add(temp);
        }
      }
      if (insertList.isNotEmpty) {
        dataList.addAll(insertList);
        dataList.sort((c1, c2) => (c2.lastMessage?.timestamp ?? 0)
            .compareTo(c1.lastMessage?.timestamp ?? 0));

        ///同步state信息
        if (AuthController.to.isLogin) {
          _fetchStateData();
        }
      } else {
        dataList.sort((c1, c2) => (c2.lastMessage?.timestamp ?? 0)
            .compareTo(c1.lastMessage?.timestamp ?? 0));
      }
      conversationIds.clear();
      conversationIds.addAll(dataList.map((e) => e.conversationID).toList());
      // if (conversationIds.isEmpty) {
      //   setEmptyType(message: "暂无聊天会话");
      // } else {
      //   setSuccessType();
      // }
      for (ConversationRefreshListener listener in observers) {
        listener.onDataRefresh(false);
      }
    }
  }

  ///刷新所有数据
  refreshAllData() {
    for (V2TimConversation element in dataList) {
      element.unreadCount = 0;
    }
    for (ConversationRefreshListener listener in observers) {
      listener.onDataRefresh(false);
    }
  }

  ///清除未读
  onClickClearUnRead() async {
    AppTipDialog().showTipDialog("一键清除未读", AppWidgetTheme.dark,
        msg: "未读消息提示会被清除，但不会删除消息。", msgFontSize: 14.sp, onCommit: () async {
      showCommit();
      await IMService().markAllMessageAsRead();
      ConversationController.to.refreshAllData();
      try {
        await request(AppApi.msgSynNoticeUnReadNumUrl);
        AppController.to.updateSysNoticeUnReadCount(0,
            sysUnReadCount: 0, noticeUnReadCount: 0);
      } catch (e) {
        //...
      }
      hiddenCommit();
      ToastUtils.show("清除成功");
    });
  }

  resetByLoginOut() {
    dataList.clear();
    conversationIds.clear();
  }

  @override
  void onClose() {
    IMService().removeImConversationListener(this);
    super.onClose();
  }
}
