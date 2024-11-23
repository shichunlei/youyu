import 'package:youyu/modules/live/common/message/live_message.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/other/scroll_loop_auto_scroll.dart';
import 'package:youyu/widgets/svga/simple_player_ext.dart';
import 'package:youyu/widgets/svga/simple_player_repeat.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/gift.dart';
import 'package:youyu/modules/live/common/message/sub/live_slide_gift_msg.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:flutter/material.dart';

///送礼物漂屏
class LiveTopScreenSubGift extends StatelessWidget {
  const LiveTopScreenSubGift(
      {super.key, required this.model});

  final LiveMessageModel<LiveSlideGiftMsg> model;

  @override
  Widget build(BuildContext context) {
    return AppStack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: ScreenUtils.screenWidth,
          height: 18.h,
          child: model.data?.svgFile != null
              ? SVGASimpleImageRepeat(
                  file: model.data?.svgFile,
                  fit: BoxFit.fitWidth,
                )
              : SVGASimpleImageExt(
                  fit: BoxFit.fitWidth,
                  assetsName: AppResource.getSvga('live_slide2'),
                ),
        ),
        Positioned(
            top: 0, bottom: 0, left: 54.w, right: 54.w, child: _scrollWidget()),
        // AppLocalImage(
        //   path: AppResource().liveSlideGift,
        //   width: 31.w,
        // )
      ],
    );
  }

  _scrollWidget() {
    List<InlineSpan> children = [];

    children.addAll(_sendUser());

    children.add(TextSpan(
      text: '向',
      style: TextStyle(
        fontSize: 12.sp,
        color: AppTheme.colorTextWhite,
      ),
    ));

    children.addAll(_receiveUser());

    children.add(TextSpan(
      text: '赠送了',
      style: TextStyle(
        fontSize: 12.sp,
        color: AppTheme.colorTextWhite,
      ),
    ));
    children.addAll(_gifts());
    if (children.isNotEmpty) {
      return ScrollLoopAutoScroll(
        duplicateChild: 1,
        gap: 1,
        scrollDirection: Axis.horizontal,
        duration: const Duration(seconds: 5),
        child: RichText(
          text: TextSpan(
            children: children,
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  ///发送者
  _sendUser() {
    return [
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: SizedBox(width: 18.w),
      ),
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Center(
          child: AppCircleNetImage(
            imageUrl: model.userInfo?.avatar ?? "",
            size: 20.w,
            borderWidth: 1.w,
            borderColor: AppTheme.colorMain,
          ),
        ),
      ),
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: SizedBox(width: 3.w),
      ),
      TextSpan(
        text: model.userInfo?.nickname ?? "",
        style: TextStyle(
          fontSize: 12.sp,
          color: AppTheme.colorMain,
        ),
      ),
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: SizedBox(width: 1.w),
      ),
    ];
  }

  ///接收者
  _receiveUser() {
    return [
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: SizedBox(width: 3.w),
      ),
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Center(
          child: AppCircleNetImage(
            imageUrl: model.data?.receiver?.avatar ?? "",
            size: 20.w,
            borderWidth: 1.w,
            borderColor: AppTheme.colorMain,
          ),
        ),
      ),
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: SizedBox(width: 3.w),
      ),
      TextSpan(
        text: model.data?.receiver?.nickname,
        style: TextStyle(
          fontSize: 12.sp,
          color: AppTheme.colorMain,
        ),
      ),
      WidgetSpan(
        child: SizedBox(width: 3.w),
      ),
    ];
  }

  ///礼物
  _gifts() {
    List<InlineSpan> giftList = [];

    for (Gift gift in model.data?.giftList ?? []) {
      giftList.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: SizedBox(width: 3.w),
        ),
      );
      List<InlineSpan> temp = [
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: SizedBox(
            width: 20.w,
            height: 20.w,
            child: Center(
              child: AppNetImage(
                imageUrl: gift.image,
                width: 20.w,
              ),
            ),
          ),
        ),
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: SizedBox(width: 4.w),
        ),
        TextSpan(
          text: 'x${gift.count}',
          style: TextStyle(
            fontSize: 12.sp,
            fontFamily: AppResource().bdt.name,
            color: AppTheme.colorMain,
          ),
        ),
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: SizedBox(width: 4.w),
        ),
      ];
      giftList.addAll(temp);
    }

    giftList.add(
      TextSpan(
        text: "快来围观吧~",
        style: TextStyle(
          fontSize: 12.sp,
          color: AppTheme.colorTextWhite,
        ),
      ),
    );
    return giftList;
  }
}
