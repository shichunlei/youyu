import 'package:youyu/utils/screen_utils.dart';
import 'package:flutter/material.dart';

enum _LiveJoinAniType {
  one,
  two,
  three;
}

///进入风格的slide
class LiveJoinSlide extends StatefulWidget {
  static int maxAnimationTime = 8;

  //透明度s
  static final gradientList = [0.0, 0.3, 0.6, 0.9, 1.0];

  const LiveJoinSlide(
      {Key? key, this.subWidget, required this.height, required this.onAniEnd})
      : super(key: key);
  final Widget? subWidget;
  final double height;
  final Function onAniEnd;

  @override
  State<LiveJoinSlide> createState() => _LiveJoinSlideState();
}

class _LiveJoinSlideState extends State<LiveJoinSlide>
    with TickerProviderStateMixin {
  _LiveJoinAniType _aniType = _LiveJoinAniType.one;

  //动画
  late AnimationController rollController;
  late AnimationController rollController2;
  late AnimationController rollController3;

  //用于引导第一个动画：从右到左
  late Animation<Offset> _animationOne;
  late Animation<Offset> _animationTwo;
  late Animation<Offset> _animationThree;

  @override
  void initState() {
    super.initState();
    //第一个动画：从右往左执行，动画的时间
    rollController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    //第二个动画：缓慢左移动
    rollController2 = AnimationController(
        duration: const Duration(milliseconds: 1400), vsync: this);
    //第三个动画：左移动消失
    rollController3 = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);

    _animationOne = Tween(begin: const Offset(2, 0), end: const Offset(0.06, 0))
        .animate(rollController);

    _animationTwo = Tween(begin: const Offset(0.06, 0), end: const Offset(0, 0))
        .animate(rollController2);

    _animationThree = Tween(begin: const Offset(0, 0), end: const Offset(-1, 0))
        .animate(rollController3);

    //第一个动画监听
    _animationOne.addListener(() {
      if (_animationOne.status == AnimationStatus.completed) {
        //第一个动画结束,播放第二个动画
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            setState(() {
              _aniType = _LiveJoinAniType.two;
            });
            rollController2.forward();
          }
        });
      }
    });
    _animationTwo.addListener(() {
      //第二个动画结束,播放第三个动画
      if (_animationTwo.status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            setState(() {
              _aniType = _LiveJoinAniType.three;
            });
            rollController3.forward();
          }
        });
      }
    });

    _animationThree.addListener(() {
      //第三个动画结束
      if (_animationThree.status == AnimationStatus.completed) {
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
    return SlideTransition(
        position: _aniPosition(),
        child: SizedBox(
          width: ScreenUtils.screenWidth,
          height: widget.height,
          child: widget.subWidget,
        ));
  }

  _aniPosition() {
    switch (_aniType) {
      case _LiveJoinAniType.one:
        return _animationOne;
      case _LiveJoinAniType.two:
        return _animationTwo;
      case _LiveJoinAniType.three:
        return _animationThree;
    }
  }

  @override
  void dispose() {
    rollController.stop();
    rollController.dispose();
    rollController2.stop();
    rollController2.dispose();
    rollController3.stop();
    rollController3.dispose();
    super.dispose();
  }
}
