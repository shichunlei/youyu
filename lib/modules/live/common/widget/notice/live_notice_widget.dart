import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_round_container.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';

class LiveNoticeWidget extends StatelessWidget {
  const LiveNoticeWidget({super.key,this.onTap});

  final Function(BuildContext context)? onTap;

  @override
  Widget build(BuildContext context) {
    return AppRoundContainer(
        bgColor: const Color(0x33FFFFFF),
        alignment: Alignment.center,
        onTap: () {
          if (onTap != null) {
            onTap!(context);
          }
        },
        padding: EdgeInsets.only(left: 7.w, right: 7.w),
        height: 22.h,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLocalImage(
              path: AppResource().liveNotice,
              width: 12.w,
            ),
            SizedBox(
              width: 2.w,
            ),
            Text(
              "公告",
              style: AppTheme().textStyle(
                  fontSize: 10.sp, color: AppTheme.colorTextWhite),
            )
          ],
        ));
  }
}
