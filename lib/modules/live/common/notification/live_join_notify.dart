import 'dart:async';
import 'dart:collection';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/modules/live/common/interactor/slide/join/live_join_slide.dart';
import 'package:youyu/modules/live/common/interactor/slide/join/sub/live_join_sub_normal.dart';
import 'package:youyu/modules/live/common/message/live_message.dart';
import 'package:youyu/modules/live/common/message/sub/live_join_msg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'abs/live_notification.dart';

///进入动画
class LiveJoinNotify extends LiveNotificationDispatch {
  Timer? _timer;
  int time = 0;

  final ListQueue<LiveMessageModel> _screenSlideQue =
      ListQueue<LiveMessageModel<LiveJoinMsg>>();

  final Rx<Widget?> _subWidgetSlide = Rx(null);
  final List<Widget> screenSlideList = [];

  LiveJoinNotify() {
    _screenSlideData();
  }

  insertJoinMessage(LiveMessageModel<LiveJoinMsg> model) {
    _screenSlideQue.add(model);
    _continueJoinScreen();
  }

  //数据
  _screenSlideData() {
    var list = [
      Obx(() {
        if (_subWidgetSlide.value != null) {
          return LiveJoinSlide(
            key: UniqueKey(),
            height: 24.h,
            subWidget: _subWidgetSlide.value,
            onAniEnd: () {
              _subWidgetSlide.value = null;
              ///通知播放礼物
              notification?.giftSlideNotify.joinNotification(false);
              ///播放进入消息
              _continueJoinScreen();
            },
          );
        } else {
          return SizedBox(
            height: 23.h,
          );
        }
      })
    ];
    screenSlideList.addAll(list);
  }

  ///继续处理漂屏
  _continueJoinScreen() async {
    LiveMessageModel? model = _screenSlideQue.lastOrNull;
    if (_subWidgetSlide.value == null && model != null) {
      Widget? subWidget;
      if (model.type == LiveMessageType.join) {
        subWidget = LiveJoinSubNormal(model: model as LiveMessageModel<LiveJoinMsg>);
      }
      if (subWidget != null) {
        notification?.giftSlideNotify.joinNotification(true);
        _subWidgetSlide.value = subWidget;
        _screenSlideQue.removeLast();
      }
    }
  }

  @override
  onClose() {
    _timer?.cancel();
    _screenSlideQue.clear();
  }
}
