import 'package:youyu/modules/live/common/message/live_message.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/live/common/message/sub/live_join_msg.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:flutter/material.dart';
import '../live_join_slide.dart';

class LiveJoinSubNormal extends StatelessWidget {
  const LiveJoinSubNormal({super.key, required this.model});

  final LiveMessageModel<LiveJoinMsg> model;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 12.w, right: 12.w),
        alignment: Alignment.centerLeft,
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              padding: EdgeInsets.only(left: 25.w, right: 12.w),
              height: 24.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99.w),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: LiveJoinSlide.gradientList,
                      colors: LiveJoinSlide.gradientList
                          .map((e) => const Color(0xFF4355FF)
                              .withAlpha(((1 - e) * 255).toInt()))
                          .toList())),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    model.userInfo?.nickname ?? "",
                    style: AppTheme().textStyle(
                        fontSize: 14.sp, color: AppTheme.colorTextWhite),
                  ),
                  Text(
                    "进入房间",
                    style: AppTheme().textStyle(
                        fontSize: 14.sp, color: const Color(0xFFFAFF00)),
                  ),
                  SizedBox(
                    width: 30.w,
                  ),
                ],
              ),
            ),
            AppNetImage(
              radius: BorderRadius.all(Radius.circular(21/2.w)),
              imageUrl: model.userInfo?.avatar,
              width: 21.w,
              height: 21.w,
              fit: BoxFit.cover,
              defaultWidget: const SizedBox.shrink(),
            ),
          ],
        ));
  }
}
