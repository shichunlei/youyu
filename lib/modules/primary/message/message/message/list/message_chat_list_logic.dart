import 'dart:async';

import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/toast_utils.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/services/im/im_listener.dart';
import 'package:youyu/services/im/im_service.dart';
import 'package:youyu/utils/format_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_receipt.dart';

class MessageChatListLogic extends AppBaseController
    with
        IMMessageC2CReadReceiptListener,
        IMMessageReceiveListener,
        IMMessageSendListener {
  //上下文
  BuildContext? context;

  ///用户系统id
  int userId = 0;

  ///最后一条消息id
  String? _lastMsgId;

  ///数据
  List<V2TimMessage> dataList = [];

  ///loading
  var isChatLoading = false.obs;

  ///是否加载完毕
  bool isLoaded = false;

  ///列表滑动
  var scrollController = ScrollController();

  //是否在拖动
  var isDragging = false.obs;

  //判断是否显示新的消息
  var isShowNewMsgTip = false.obs;

  var isShowMoreLoading = false.obs;

  //滑动计时器
  Timer? _scrollTimer;

  //对方用户昵称
  String nickName = '';

  @override
  void onInit() {
    super.onInit();
    //绑定监听
    IMService().addImReceiveMessageListener(this);
    IMService().addC2CReadReceiptListener(this);
    IMService().addMessageSendListener(this);
  }

  ///获取历史消息
  getHistoryMsg(bool isFirst) async {
    try {
      if (isFirst) {
        isShowMoreLoading.value = true;
        // isChatLoading.value = true;
      }

      List<V2TimMessage> msgs = await IMService()
          .getUserGetList(userID: userId.toString(), lastID: _lastMsgId);
      if (isFirst) {
        dataList.clear();
      }
      for (V2TimMessage message in msgs) {
        //添加内容
        dataList.add(message);
      }
      if (msgs.isNotEmpty) {
        _lastMsgId = msgs.last.msgID ?? "";
      }
      if (msgs.length < 20) {
        isLoaded = true;
      }

      if (context != null) {
        (context as StatefulElement).markNeedsBuild();
      } else {
        (Get.context as StatefulElement).markNeedsBuild();
      }
      // if (isFirst) {
      //   isChatLoading.value = false;
      // }
    } catch (e) {
      // isShowMoreLoading.value = false;
      ToastUtils.show("会话加载失败");
    }
  }

  ///拖动状态
  //拖动 (未来可能再进行体验优化)
  onPointerMove(PointerMoveEvent event) {
    if (context != null) {
      //内容大于容器高度时
      if (scrollController.position.pixels > 200.h) {
        isDragging.value = true;
      }
    }
  }

  //滚动状态
  onScrollViewDidScroll(ScrollNotification scrollNotification) {
    switch (scrollNotification.runtimeType) {
      case ScrollStartNotification:
        //开始滚动
        break;
      case ScrollUpdateNotification:
        //正在滚动
        break;
      case ScrollEndNotification:
        //滚动停止
        //判断是否在底部
        if (scrollController.position.pixels <= 200.h) {
          //如果在最后，就隐藏新消息
          isDragging.value = false;
          isShowNewMsgTip.value = false;
        }
        break;
      case OverscrollNotification:
        //滚动到边界
        break;
    }
  }

  ///已读回调
  @override
  onMessageC2CReadReceipt(List<V2TimMessageReceipt> receiptList) {
    for (V2TimMessage value in dataList) {
      value.isPeerRead = true;
    }
    if (context != null) {
      (context as StatefulElement).markNeedsBuild();
    }
  }

  ///收到新消息
  @override
  onReceiveMessage(V2TimMessage msg) {
    if (FormatUtil.getRealId(msg.userID!) == userId) {
      insertMessage(false, msg);
      IMService().markC2CMessageAsRead(userId.toString());
    }
  }

  ///IMMessageSendListener
  @override
  onSendMessageSuccess(
      {required String? sysUserId,
      required String? imGroupId,
      required V2TimMessage msg}) {
    if (userId.toString() == sysUserId) {
      insertMessage(true, msg);
    }
  }

  ///插入消息
  insertMessage(bool isSender, V2TimMessage model) {
    dataList.insert(0, model);

    ///滑动处理
    if (context != null) {
      if (isDragging.value && !isSender) {
        //如果有拖动操作
        //显示新消息
        isShowNewMsgTip.value = true;
      } else {
        if (context != null) {
          if (context!.mounted) {
            (context as StatefulElement).markNeedsBuild();
          }
        }
        //如果没有拖动操作，直接动画滑动
        _scrollTimer?.cancel();
        _scrollTimer = Timer(const Duration(milliseconds: 10), () {
          if (scrollController.hasClients) {
            scrollController.animateTo(0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut);
          }
        });
      }
    }
  }

  ///隐藏tip
  void hiddenTip() {
    if (isShowNewMsgTip.value) {
      isShowNewMsgTip.value = false;
      scrollController.jumpTo(0);
    }
    if (context != null) {
      (context as StatefulElement).markNeedsBuild();
    }
  }

  ///删除消息
  delMessage(V2TimMessage model) async {
    await IMService().deleteMessage(model);
    dataList.remove(model);
    if (context != null) {
      (context as StatefulElement).markNeedsBuild();
    }
  }

  @override
  void onClose() {
    super.onClose();
    _scrollTimer?.cancel();
    IMService().removeImReceiveMessageListener(this);
    IMService().removeC2CReadReceiptListener(this);
  }
}
