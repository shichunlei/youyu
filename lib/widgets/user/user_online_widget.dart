import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:flutter/material.dart';

class UserOnlineWidget extends StatelessWidget {
  const UserOnlineWidget({super.key, this.height});

  final double? height;

  @override
  Widget build(BuildContext context) {
    return AppRow(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      color: const Color(0x26FFFFFF),
      radius: 99.w,
      height: height ?? 16.h,
      children: [
        AppContainer(
          radius: 99.w,
          height: 6.h,
          width: 6.h,
          color: const Color(0xFF05F200),
        ),
        SizedBox(
          width: 2.w,
        ),
        Text(
          '在线',
          style: AppTheme().textStyle(
              fontSize: 12.sp, color: AppTheme.colorTextWhite),
        )
      ],
    );
  }
}
