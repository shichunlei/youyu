import 'package:youyu/utils/screen_utils.dart';
import 'package:flutter/material.dart';

///顶部风格的slide
class LiveTopScreenSlide extends StatefulWidget {
  static int maxAnimationTime = 8;

  const LiveTopScreenSlide(
      {Key? key, this.subWidget, required this.height, required this.onAniEnd})
      : super(key: key);
  final Widget? subWidget;
  final double height;
  final Function(int index) onAniEnd;

  @override
  State<LiveTopScreenSlide> createState() => _LiveTopScreenSlideState();
}

class _LiveTopScreenSlideState extends State<LiveTopScreenSlide>
    with TickerProviderStateMixin {
  //动画
  late AnimationController rollController;
  late AnimationController rollController2;

  //用于引导第一个动画：从右到左
  late Animation<Offset> _animationOne;
  late Animation<Offset> _animationTwo;

  bool firstAnimation = true;

  @override
  void initState() {
    super.initState();
    //第一个动画：从右往左执行，动画的时间
    rollController = AnimationController(
        duration: const Duration(milliseconds: 1400), vsync: this);
    //第二个动画：向右消失
    rollController2 = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    _animationOne = Tween(begin: const Offset(2, 0), end: const Offset(0, 0))
        .animate(CurvedAnimation(
            parent: rollController,
            curve: const Interval(
              0.4,
              1,
              curve: ElasticOutCurve(1),
            )));

    _animationTwo = Tween(begin: const Offset(0, 0), end: const Offset(-2, 0))
        .animate(rollController2);

    //第一个动画监听
    _animationOne.addListener(() {
      if (_animationOne.status == AnimationStatus.completed) {
        //第一个动画结束,播放第二个动画
        Future.delayed(const Duration(milliseconds: 2500), () {
          if (mounted) {
            setState(() {
              firstAnimation = false;
            });
            rollController2.forward();
          }
        });
      }
    });
    _animationTwo.addListener(() {
      //第二个动画结束
      if (_animationTwo.status == AnimationStatus.completed) {
        if (mounted) {
          widget.onAniEnd((widget.key as ValueKey<int>).value);
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
    return SlideTransition(
        position: firstAnimation ? _animationOne : _animationTwo,
        child: SizedBox(
          width: ScreenUtils.screenWidth,
          height: widget.height,
          child: widget.subWidget,
        ));
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
