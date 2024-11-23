import 'dart:async';
import 'dart:collection';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/modules/live/common/interactor/slide/vip/live_vip_slide.dart';
import 'package:youyu/modules/live/common/interactor/slide/vip/sub/live_vip_sub_normal.dart';
import 'package:youyu/modules/live/common/message/live_message.dart';
import 'package:youyu/modules/live/common/message/sub/live_vip_msg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'abs/live_notification.dart';

///vip漂屏
class LiveVipSlideNotify extends LiveNotificationDispatch {
  Timer? _timer;
  int time = 0;

  final ListQueue<LiveMessageModel> _screenSlideQue =
      ListQueue<LiveMessageModel>();

  final Rx<Widget?> _subWidgetSlide = Rx(null);
  final List<Widget> vipSlideList = [];

  LiveVipSlideNotify() {
    //vip漂屏
    _vipScreenSlideData();
  }

  //vip漂屏数据
  _vipScreenSlideData() {
    var list = [
      Obx(() {
        if (_subWidgetSlide.value != null) {
          return LiveVipSlide(
            key: UniqueKey(),
            height: 20.h,
            subWidget: _subWidgetSlide.value,
            onAniEnd: () {
              _subWidgetSlide.value = null;
              _continueVipScreen();
            },
          );
        } else {
          return SizedBox(
            height: 20.h,
          );
        }
      })
    ];
    vipSlideList.addAll(list);
  }

  _dealvipTimer() {
    _timer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (time % 3 == 0) {
      } else if (time % 3 == 1) {
        _screenSlideQue.add(LiveMessageModel<LiveVipMsg>(
            isManager: false,
            type: LiveMessageType.vip,
            data: LiveVipMsg(isSVip: true)));
      } else if (time % 3 == 2) {
        _screenSlideQue.add(LiveMessageModel<LiveVipMsg>(
            isManager: false,
            type: LiveMessageType.vip,
            data: LiveVipMsg(isSVip: false)));
      }
      _continueVipScreen();
      time++;
    });
  }

  ///继续处理vip漂屏
  _continueVipScreen() async {
    LiveMessageModel? model = _screenSlideQue.lastOrNull;
    if (_subWidgetSlide.value == null && model != null) {
      Widget? subWidget;
      if (model.type == LiveMessageType.vip) {
        subWidget = LiveVipSubNormal(model: model as LiveMessageModel<LiveVipMsg>);
      }
      if (subWidget != null) {
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
