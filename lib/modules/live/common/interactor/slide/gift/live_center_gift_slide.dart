import 'dart:async';

import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/modules/live/common/interactor/slide/gift/sub/live_center_gift_sub_normal.dart';
import 'package:flutter/material.dart';
import '../../../message/sub/live_gift_msg.dart';

///礼物风格的slide
class LiveCenterGiftSlide extends StatefulWidget {
  static int maxAnimationTime = 8;

  //透明度s
  static final gradientList = [0.0, 0.3, 0.6, 0.9, 1.0];

  const LiveCenterGiftSlide(
      {Key? key, this.subWidget, required this.height, required this.onAniEnd})
      : super(key: key);
  final LiveCenterGiftSubNormal? subWidget;
  final double height;
  final Function onAniEnd;

  @override
  State<LiveCenterGiftSlide> createState() => LiveCenterGiftSlideState();
}

class LiveCenterGiftSlideState extends State<LiveCenterGiftSlide>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  //动画
  late AnimationController rollController;
  late AnimationController rollController2;

  //用于引导第一个动画：从右到左
  late Animation<Offset> _animationOne;
  late Animation<double> _animationTwo;
  bool isFirstAniEnd = false;
  bool isEnd = false;
  Timer? _endTimer;

  //总礼物数量放在这里
  int _allGiftCount = 0;

  @override
  void initState() {
    super.initState();
    _allGiftCount = widget.subWidget?.model.data?.gift?.count ?? 0;

    //第一个动画：从右往左执行，动画的时间
    rollController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    //第二个动画：消失动画
    rollController2 = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this);
    _animationOne = Tween(begin: const Offset(-2, 0), end: const Offset(0, 0))
        .animate(rollController);

    _animationTwo = Tween<double>(begin: 1.0, end: 0).animate(rollController2);

    //第一个动画监听
    _animationOne.addListener(() {
      if (_animationOne.status == AnimationStatus.completed) {
        isFirstAniEnd = true;
        _endTimer = Timer(const Duration(milliseconds: 1100), () {
          if (mounted) {
            isEnd = true;
            setState(() {
              rollController2.forward();
            });
          }
        });
      }
    });
    _animationTwo.addListener(() {
      //第二个动画结束
      if (_animationTwo.status == AnimationStatus.completed) {
        if (mounted) {
          widget.onAniEnd();
        }
      }
    });

    rollController.forward();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _slideItem();
  }

  _slideItem() {
    return FadeTransition(
      opacity: _animationTwo,
      child: SlideTransition(
          position: _animationOne,
          child: SizedBox(
            width: ScreenUtils.screenWidth,
            height: widget.height,
            child: widget.subWidget,
          )),
    );
  }

  addCount(LiveGiftMsg? newMsg, Function(int allGiftCount) onAddCount) {
    ///设置新的数量
    _allGiftCount = _allGiftCount + (newMsg?.gift?.count ?? 0);
    if (newMsg != null && !isEnd) {
      if (isFirstAniEnd) {
        onAddCount(_allGiftCount);
        _endTimer?.cancel();
        _endTimer = Timer(const Duration(seconds: 4), () {
          if (mounted) {
            isEnd = true;
            setState(() {
              rollController2.forward();
            });
          }
        });
      } else {
        onAddCount(_allGiftCount);
      }
    }
  }

  @override
  void dispose() {
    _endTimer?.cancel();
    rollController.stop();
    rollController.dispose();
    rollController2.stop();
    rollController2.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
