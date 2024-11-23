import 'package:youyu/utils/screen_utils.dart';
import 'package:flutter/material.dart';

///vip风格的slide
class LiveVipSlide extends StatefulWidget {
  static int maxAnimationTime = 8;

  const LiveVipSlide(
      {Key? key, this.subWidget, required this.height, required this.onAniEnd})
      : super(key: key);
  final Widget? subWidget;
  final double height;
  final Function onAniEnd;

  @override
  State<LiveVipSlide> createState() => _LiveVipSlideState();
}

class _LiveVipSlideState extends State<LiveVipSlide>
    with TickerProviderStateMixin {
  //动画
  late AnimationController rollController;
  late AnimationController rollController2;

  //用于引导第一个动画：从右到左
  late Animation<Offset> _animationOne;
  late Animation<double> _animationTwo;

  @override
  void initState() {
    super.initState();
    //第一个动画：从右往左执行，动画的时间
    rollController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    //第二个动画：消失动画
    rollController2 = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    _animationOne = Tween(begin: const Offset(2, 0), end: const Offset(0, 0))
        .animate(rollController);

    _animationTwo = Tween<double>(begin: 1.0, end: 0).animate(rollController2);

    //第一个动画监听
    _animationOne.addListener(() {
      if (_animationOne.status == AnimationStatus.completed) {
        //第一个动画结束,播放第二个动画
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
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

  @override
  void dispose() {
    rollController.stop();
    rollController.dispose();
    rollController2.stop();
    rollController2.dispose();
    super.dispose();
  }
}
