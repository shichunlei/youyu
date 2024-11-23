import 'package:youyu/config/resource.dart';
import 'package:youyu/models/gift.dart';
import 'package:youyu/modules/live/common/message/live_message.dart';
import 'package:youyu/modules/live/common/message/sub/live_game_msg.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/other/scroll_loop_auto_scroll.dart';
import 'package:youyu/widgets/svga/simple_player_ext.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:flutter/material.dart';

///TODO:游戏漂屏(后面在处理)
class LiveTopScreenSubGame extends StatelessWidget {
  const LiveTopScreenSubGame(
      {super.key, required this.model});

  final LiveMessageModel<LiveGameMsg> model;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppStack(
          width: double.infinity,
          height: 18.h,
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: ScreenUtils.screenWidth,
              height: 18.h,
              child: SVGASimpleImageExt(
                fit: BoxFit.fitWidth,
                assetsName: AppResource.getSvga('live_slide1'),
              ),
            ),
            Positioned(
                top: 0,
                bottom: 0,
                left: 54.w,
                right: 54.w,
                child: _scrollWidget()),
          ]),
    );
  }

  _scrollWidget() {
    List<InlineSpan> children = [];
    children.add(
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: SizedBox(width: 12.w),
      ),
    );
    children.add(TextSpan(
      text: '恭喜',
      style: TextStyle(
        fontSize: 12.sp,
        color: Colors.white,
      ),
    ));

    children.addAll(_receiveUser());

    children.add(TextSpan(
      text: '在${model.data?.name}获得',
      style: TextStyle(
        fontSize: 12.sp,
        color: Colors.white,
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

  ///接收者
  _receiveUser() {
    return [
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: AppNetImage(
          imageUrl: model.userInfo?.avatar ?? "",
          width: 18.h,
          height: 18.h,
        ),
      ),
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: SizedBox(width: 3.w),
      ),
      TextSpan(
        text: "宝藏男孩",
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
    giftList.add(
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: SizedBox(width: 3.w),
      ),
    );
    for (Gift gift in model.data?.giftList ?? []) {
      List<InlineSpan> temp = [
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: SizedBox(
            width: 18.h,
            height: 18.h,
            child: Center(
              child: AppNetImage(
                imageUrl: gift.image,
                width: 18.h,
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
        text: "运气爆棚呀~",
        style: TextStyle(
          fontSize: 12.sp,
          color: AppTheme.colorTextWhite,
        ),
      ),
    );
    return giftList;
  }
}
