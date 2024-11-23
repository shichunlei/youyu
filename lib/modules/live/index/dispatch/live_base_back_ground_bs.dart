import 'dart:io';

import 'package:youyu/models/room_background.dart';
import 'package:youyu/modules/live/common/widget/bg/live_bg_widget.dart';
import 'package:youyu/services/async_down_service.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:flutter/material.dart';

mixin LiveBaseBackGroundBsListener {
  //处理背景
  void onBackGroundProgress(RoomBackGround? backGround);

  GlobalKey<LiveBgWidgetState> onBackGroundKey();
}

///背景图业务
class LiveBaseBackGroundBs
    with
        LiveBaseBackGroundBsListener,
        AsyncDownListener {
  final GlobalKey<LiveBgWidgetState> _bgKey = GlobalKey<LiveBgWidgetState>();


  LiveBaseBackGroundBs() {
    AsyncDownService().addDownListener(DownType.liveBackGround, this);
  }

  @override
  void onBackGroundProgress(RoomBackGround? backGround) {
    if (backGround != null) {
      if (backGround.suffix.contains("svg")) {
        AsyncDownService()
            .addTask(DownType.liveBackGround, DownModel(url: backGround.url));
      } else {
        _onChangeBackGround(LiveBackGroundType.image, imageUrl: backGround.url);
      }
    }
  }

  @override
  GlobalKey<LiveBgWidgetState> onBackGroundKey() {
    return _bgKey;
  }

  ///AsyncDownListener
  //下载成功
  @override
  onDownLoadSuccess(DownType downType, File file) {
    _onChangeBackGround(LiveBackGroundType.svg, svgFile: file);
  }

  //下载失败
  @override
  onDownLoadError(DownType downType) {}

  _onChangeBackGround(LiveBackGroundType type,
      {String? imageUrl, File? svgFile}) {
    _bgKey.currentState
        ?.updateBackGround(type, imageUrl: imageUrl, svgFile: svgFile);
  }

  //释放
  onClose() {
    AsyncDownService().removeDownListener(DownType.liveBackGround, this);
  }
}
