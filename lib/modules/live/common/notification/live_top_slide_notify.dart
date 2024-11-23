import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/modules/live/common/interactor/slide/top_screen/live_top_screen_slide.dart';
import 'package:youyu/modules/live/common/interactor/slide/top_screen/sub/live_top_screen_sub_game.dart';
import 'package:youyu/modules/live/common/interactor/slide/top_screen/sub/live_top_screen_sub_gift.dart';
import 'package:youyu/modules/live/common/message/live_message.dart';
import 'package:youyu/modules/live/common/message/sub/live_game_msg.dart';
import 'package:youyu/modules/live/common/message/sub/live_slide_gift_msg.dart';
import 'package:youyu/services/async_down_service.dart';
import 'package:youyu/services/im/model/ext/im_slide_gift_model.dart';
import 'package:youyu/services/im/model/im_custom_message_mdoel.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'abs/live_notification.dart';

///顶部漂屏
class LiveTopSlideNotify extends LiveNotificationDispatch {
  Timer? _timer;
  int time = 0;

  final ListQueue<LiveMessageModel> _screenSlideQue =
      ListQueue<LiveMessageModel>();

  final List<Widget> screenSlideList = [];

  final List<Rx<Widget?>> _topSlideSubWidget = [Rx(null),Rx(null),Rx(null)];

  LiveTopSlideNotify() {
    //顶部漂屏
    _topScreenSlideData();
  }

  insertTopSlide(
      IMCustomMessageModel<IMSlideGiftModel> imModel, bool isManager) async {
    //下载svg
    File? file = await AsyncDownService().addTask(
        DownType.slideGift, DownModel(url: (imModel.data?.svge ?? "")));

    //转live model
    LiveMessageModel<LiveSlideGiftMsg> model = LiveMessageModel(
        isManager: isManager,
        type: LiveMessageType.gift,
        userInfo: imModel.userInfo,
        timestamp: imModel.timestamp,
        data: LiveSlideGiftMsg(
            sender: imModel.userInfo,
            receiver: imModel.data?.toUserInfo,
            giftList: imModel.data?.giftList,
            svgFile: file));

    _screenSlideQue.add(model);
    _continueTopScreen();
  }

  //顶部漂屏数据
  _topScreenSlideData() {
    double topScreenSlideH = 34.h;
    double topScreenSpace = 13.h;
    screenSlideList.clear();
    for (int i = 0; i < _topSlideSubWidget.length; i++) {
      screenSlideList.add(Obx(() => Column(
            children: [
              SizedBox(
                height: topScreenSpace,
              ),
              _topSlideSubWidget[i].value != null
                  ? LiveTopScreenSlide(
                      key: ValueKey(i),
                      subWidget: _topSlideSubWidget[i].value,
                      height: topScreenSlideH,
                      onAniEnd: (index) {
                        _topSlideSubWidget[index].value = null;
                        _continueTopScreen();
                      },
                    )
                  : SizedBox(
                      height: topScreenSlideH,
                    ),
            ],
          )));
    }
  }

  ///继续处理顶部漂屏
  _continueTopScreen() async {
    Future(() {
      for (int i = 0; i < _topSlideSubWidget.length; i++) {
        LiveMessageModel? model = _screenSlideQue.lastOrNull;
        if (_topSlideSubWidget[i].value == null) {
          Widget? subWidget = _createSubWidget(model);
          if (subWidget != null) {
            _topSlideSubWidget[i].value = subWidget;
            _screenSlideQue.removeLast();
            continue;
          }
        }
      }
    });
  }

  _createSubWidget(LiveMessageModel? model) {
    Widget? subWidget;
    if (model != null) {
      if (model.type == LiveMessageType.gift) {
        subWidget = LiveTopScreenSubGift(model: model as LiveMessageModel<LiveSlideGiftMsg>);
      } else if (model.type == LiveMessageType.game) {
        subWidget = LiveTopScreenSubGame(model: model as LiveMessageModel<LiveGameMsg>);
      }
    }
    return subWidget;
  }

  @override
  onClose() {
    _timer?.cancel();
    _screenSlideQue.clear();
  }
}
