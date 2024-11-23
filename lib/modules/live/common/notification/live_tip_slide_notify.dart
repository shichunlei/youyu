import 'dart:async';
import 'dart:collection';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/modules/live/common/interactor/slide/tip/live_tip_slide.dart';
import 'package:youyu/modules/live/common/interactor/slide/tip/sub/live_tip_sub_level.dart';
import 'package:youyu/modules/live/common/message/live_message.dart';
import 'package:youyu/modules/live/common/message/sub/live_tag_level_msg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'abs/live_notification.dart';

///tip漂屏
class LiveTipSlideNotify extends LiveNotificationDispatch {
  Timer? _timer;
  int time = 0;

  final ListQueue<LiveMessageModel> _screenSlideQue =
      ListQueue<LiveMessageModel>();

  final Rx<Widget?> _subWidgetSlide = Rx(null);
  final List<Widget> screenSlideList = [];

  LiveTipSlideNotify() {
    //tip漂屏
    _tipScreenSlideData();
  }

  //tip漂屏数据
  _tipScreenSlideData() {
    var list = [
      Obx(() {
        if (_subWidgetSlide.value != null) {
          return LiveTipSlide(
            key: UniqueKey(),
            height: 36.h,
            subWidget: _subWidgetSlide.value,
            onAniEnd: () {
              _subWidgetSlide.value = null;
              _continueTipScreen();
            },
          );
        } else {
          return SizedBox(
            height: 36.h,
          );
        }
      })
    ];
    screenSlideList.addAll(list);
  }

  ///继续处理tip漂屏
  _continueTipScreen() async {
    LiveMessageModel? model = _screenSlideQue.lastOrNull;
    if (_subWidgetSlide.value == null && model != null) {
      Widget? subWidget;
      if (model.type == LiveMessageType.tagLevel) {
        subWidget = LiveTipSubLevel(
            model: model as LiveMessageModel<LiveTagLevelMsg>);
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
