import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';

class UserSexAgeWidget extends StatelessWidget {
  const UserSexAgeWidget({super.key, this.height, this.gender, this.age});

  ///0:未知 1:男 2:女
  final int? gender;
  final int? age;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return AppRow(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      color: gender == 1 ? const Color(0xFF9DD7F9) : const Color(0xFFFFE8F3),
      radius: 99.w,
      height: height ?? 16.h,
      children: [
        AppLocalImage(
          path: _sex(),
          height: 12.h,
          imageColor: _sexColor(),
        ),
        SizedBox(
          width: 2.w,
        ),
        Text(
          '${age ?? 0}',
          style: AppTheme().textStyle(fontSize: 12.sp, color: _sexColor()),
        )
      ],
    );
  }

  _sex() {
    if (gender == 1) {
      return AppResource().boy;
    } else  {
      return AppResource().girl;
    }
  }

  _sexColor() {
    if (gender == 1) {
      return const Color(0xFF3BB0F3);
    } else {
      return const Color(0xFFFF56A6);
    }
  }
}
