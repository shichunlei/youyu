import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/live/common/message/sub/live_gift_msg.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:flutter/material.dart';

import '../../../../message/live_message.dart';
import '../live_center_gift_slide.dart';

class LiveCenterGiftSubNormal extends StatefulWidget {
  const LiveCenterGiftSubNormal(
      {super.key,
      required this.model,
      required this.allGiftCount});

  final int allGiftCount;
  final LiveMessageModel<LiveGiftMsg> model;

  @override
  State<LiveCenterGiftSubNormal> createState() =>
      LiveCenterGiftSubNormalState();
}

class LiveCenterGiftSubNormalState extends State<LiveCenterGiftSubNormal>
    with TickerProviderStateMixin {
  late AnimationController _scaleAnimationController;
  late Animation<double> _scaleAni;

  late AnimationController _scaleAnimationController2;
  late Animation<double> _scaleAni2;

  bool _firstAniEnd = false;
  bool twoAniEnd = true;

  @override
  void initState() {
    super.initState();
    //放大
    _scaleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAni = Tween(begin: 1.0, end: 1.7).animate(_scaleAnimationController);
    //缩小
    _scaleAnimationController2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAni2 = Tween(begin: 1.7, end: 1.0).animate(_scaleAnimationController);

    //监听
    _scaleAnimationController.addListener(() {
      if (_scaleAni.isCompleted) {
        _firstAniEnd = true;
        _scaleAnimationController2.forward();
      }
    });

    _scaleAnimationController2.addListener(() {
      if (_scaleAni2.isCompleted) {
        twoAniEnd = true;
      }
    });
    _scaleAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (_scaleAni.isCompleted) {
      _scaleAnimationController.forward();
    }
    return Container(
      margin: EdgeInsets.only(left: 12.w, right: 12.w),
      alignment: Alignment.centerLeft,
      width: double.infinity,
      height: double.infinity,
      child: Container(
        padding: EdgeInsets.only(left: 3.w, right: 12.w),
        height: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99.w),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: LiveCenterGiftSlide.gradientList,
                colors: LiveCenterGiftSlide.gradientList
                    .map((e) => const Color(0x802C2C2C)
                        .withAlpha(((1 - e) * 255).toInt()))
                    .toList())),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppCircleNetImage(
              imageUrl: widget.model.data?.sender?.avatar,
              size: 29.w,
              errorSize: 10.w,
              defaultWidget: null,
            ),
            SizedBox(
              width: 3.w,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.model.data?.sender?.nickname ?? "",
                    style: AppTheme().textStyle(
                        fontSize: 12.sp, color: AppTheme.colorTextWhite),
                  ),
                  RichText(
                      text: TextSpan(
                    text: '送给 ',
                    style: AppTheme().textStyle(
                        color: AppTheme.colorTextWhite, fontSize: 12.sp),
                    children: <TextSpan>[
                      TextSpan(
                          text: widget.model.data?.receiver?.nickname ?? "",
                          style: AppTheme().textStyle(
                              color: AppTheme.colorMain,
                              fontSize: 12.sp))
                    ],
                  )),
                ],
              ),
            ),
            SizedBox(
              width: 32.w,
            ),
            AppNetImage(
              imageUrl: widget.model.data?.gift?.image,
              width: 30.w,
              defaultWidget: const SizedBox.shrink(),
            ),
            SizedBox(
              width: 13.w,
            ),
            Flexible(
                child: ScaleTransition(
                    scale: _firstAniEnd ? _scaleAni2 : _scaleAni,
                    child: Text('x${widget.allGiftCount}',
                        style: AppTheme().textStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                            fontFamily: AppResource().bdt.name,
                            color: const Color(0xFFFFBB00))))),
            SizedBox(
              width: 8.w,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scaleAnimationController.stop();
    _scaleAnimationController.dispose();
    _scaleAnimationController2.stop();
    _scaleAnimationController2.dispose();
    super.dispose();
  }
}
