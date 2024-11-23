import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/models/gift.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:flutter/material.dart';

class UserGiftWidget extends StatelessWidget {
  const UserGiftWidget({super.key, required this.gift, required this.onClick});

  final Gift gift;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return AppColumn(
      mainAxisAlignment: MainAxisAlignment.center,
      color: const Color(0xFF1E1E1E),
      radius: 8.w,
      onTap: () {
        onClick();
      },
      children: [
        AppNetImage(
          width: double.infinity,
          height: 45.h,
          imageUrl: gift.image,
          fit: BoxFit.contain,
          defaultWidget: const SizedBox.shrink(),
        ),
        SizedBox(
          height: 10.h,
        ),
        // Text(
        //   gift.name,
        //   style: AppTheme().textStyle(
        //       fontSize: 12.sp, color: AppTheme.colorTextWhite),
        // ),
        // SizedBox(
        //   height: 3.h,
        // ),
        Opacity(
          opacity: 0.7,
          child: Text(
            "X${gift.count}",
            style: AppTheme().textStyle(
                fontSize: 13.sp, color: AppTheme.colorTextWhite),
          ),
        )
      ],
    );
  }
}
