import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/live/common/message/live_message.dart';
import 'package:youyu/modules/live/common/message/sub/live_tag_level_msg.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:flutter/material.dart';

class LiveTipSubLevel extends StatelessWidget {
  const LiveTipSubLevel({super.key, required this.model});

  final LiveMessageModel<LiveTagLevelMsg> model;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 12.w, right: 12.w),
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              padding: EdgeInsets.only(left: 8.w),
              child: Container(
                padding: EdgeInsets.only(left: 30.w, right: 12.w),
                height: 28.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(99.w),
                    border: Border.all(
                      width: 1.w,
                      color: AppTheme.colorTextWhite,
                    ),
                    gradient: model.data?.tagBgGradient),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "恭喜",
                      style: AppTheme().textStyle(
                          fontSize: 14.sp,
                          color: AppTheme.colorTextWhite),
                    ),
                    Flexible(
                      child: Text(
                        model.userInfo?.nickname ?? "",
                        style: AppTheme().textStyle(
                            fontSize: 14.sp,
                            color: AppTheme.colorTextWhite),
                      ),
                    ),
                    Text(
                      "升级为",
                      style: AppTheme().textStyle(
                          fontSize: 14.sp,
                          color: AppTheme.colorTextWhite),
                    ),
                    Text(
                      "${model.data?.tagName}爵位",
                      style: AppTheme().textStyle(
                          fontSize: 14.sp, color: const Color(0xFFFFF500)),
                    ),
                  ],
                ),
              ),
            ),
            AppNetImage(
              imageUrl: model.data?.tagImage,
              width: 36.w,
              height: 36.w,
              defaultWidget: const SizedBox.shrink(),
            ),
          ],
        ));
  }
}
