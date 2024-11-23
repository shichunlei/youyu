import 'dart:async';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/modules/live/common/message/live_message.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:youyu/services/trtc/trtc_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveScreenListLogic extends AppBaseController {
  //遮罩变化队列
  // var maskPriorityQueue = PriorityQueue<int>((b, a) => a.compareTo(b));
  LiveScreenMaskType maskType = LiveScreenMaskType.normal;
  AnimationController? maskController;
  Timer? _maskTimer;

  //是否在拖动
  var isDragging = false.obs;

  //判断是否显示新的消息
  var isShowNewMsgTip = false.obs;

  BuildContext? context;
  final ScrollController scrollController = ScrollController();

  Timer? _scrollTimer;

  var scrollOffset = 0.0.obs;

  Function? onScrollUpdate;

  ///插入消息
  insertMessage(LiveMessageModel model, int tab) {
    if (context != null) {
      (context as StatefulElement).markNeedsBuild();
    }

    switch (tab) {
      case 0:
        {
          TRTCService().allScreenList.add(model);

          ///处理最大显示消息树
          if (TRTCService().allScreenList.length > 200) {
            TRTCService().allScreenList =
                TRTCService().allScreenList.sublist(0, 100);
          }
        }
        break;
      case 1:
        {
          TRTCService().chatScreenList.add(model);

          ///处理最大显示消息树
          if (TRTCService().chatScreenList.length > 200) {
            TRTCService().chatScreenList =
                TRTCService().chatScreenList.sublist(0, 100);
          }
        }
        break;
      case 2:
        {
          TRTCService().giftScreenList.add(model);

          ///处理最大显示消息树
          if (TRTCService().giftScreenList.length > 200) {
            TRTCService().giftScreenList =
                TRTCService().giftScreenList.sublist(0, 100);
          }
        }
        break;
    }

    ///滑动处理
    if (context != null) {
      if (isDragging.value) {
        //如果有拖动操作
        //显示新消息
        isShowNewMsgTip.value = true;
      } else {
        //如果没有拖动操作，直接动画滑动
        _scrollTimer = Timer(const Duration(milliseconds: 10), () {
          scrollController.animateTo(scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut);
        });
      }
    }
  }

  ///清理屏幕
  clearAllMessage(int tab) {
    switch (tab) {
      case 0:
        TRTCService().allScreenList.clear();
        break;
      case 1:
        TRTCService().chatScreenList.clear();
        break;
      case 2:
        TRTCService().giftScreenList.clear();
        break;
    }

    if (context != null) {
      (context as StatefulElement).markNeedsBuild();
    }
  }

  ///处理遮罩
  processMaskType(LiveScreenMaskType maskType) {
    // maskPriorityQueue.add(maskType.type);
    // this.maskType.value = LiveScreenMaskType.fromType(maskPriorityQueue.first);
    // maskPriorityQueue.removeFirst();
    if (this.maskType != maskType) {
      this.maskType = maskType;
      // if (context != null) {
      //   (context as StatefulElement).markNeedsBuild();
      // }
      if (maskType == LiveScreenMaskType.normal) {
        maskController?.reset();
      } else {
        _maskTimer?.cancel();
        _maskTimer = Timer(const Duration(milliseconds: 240), () {
          maskController?.forward();
        });
      }
    }
  }

  ///拖动状态
  //拖动 (未来可能再进行体验优化)
  void onPointerMove(PointerMoveEvent event) {
    if (context != null) {
      //内容大于容器高度时
      if (scrollController.position.extentInside !=
          scrollController.position.extentTotal) {
        isDragging.value = true;
      }
    }
  }

  //滚动状态
  void onScrollViewDidScroll(ScrollNotification scrollNotification) {
    if (scrollNotification is ScrollUpdateNotification) {
      if (onScrollUpdate != null) {
        onScrollUpdate!();
      }
    }

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
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
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

  @override
  void onClose() {
    _maskTimer?.cancel();
    _scrollTimer?.cancel();
    super.onClose();
  }
}
