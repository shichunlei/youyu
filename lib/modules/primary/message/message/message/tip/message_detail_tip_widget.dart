import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/widgets/svga/simple_player_ext.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';

class MessageDetailTipWidget extends StatelessWidget {
  const MessageDetailTipWidget(
      {super.key,
      required this.name,
      required this.onClickToLive,
      required this.onClickClose});

  final String name;
  final Function onClickToLive;
  final Function onClickClose;

  @override
  Widget build(BuildContext context) {
    return AppRow(
      padding: EdgeInsets.only(left: 11.w),
      radius: 6.w,
      width: double.infinity,
      height: double.infinity,
      gradientStartColor: const Color(0x33C9EB58),
      gradientEndColor: const Color(0x338ACD4E),
      children: [
        Expanded(
          child: Text(
            'Ta在$name的房间',
            style: AppTheme().textStyle(fontSize: 12.sp, color: const Color(0xFF7B9F02)),
          ),
        ),
        AppRow(
          onTap: () {
            onClickToLive();
          },
          mainAxisAlignment: MainAxisAlignment.center,
          gradient: AppTheme().btnGradient,
          width: 94.w,
          height: 32.h,
          radius: 16.h,
          children: [
            SizedBox(
              width: 8.w,
              height: 8.w,
              child: SVGASimpleImageExt(
                assetsName: AppResource.getSvga('audio_list_white'),
              ),
            ),
            SizedBox(
              width: 6.w,
            ),
            Text(
              "去找TA",
              style: AppTheme().textStyle(
                  fontSize: 14.sp, color: AppTheme.colorTextWhite),
            )
          ],
        ),
        AppContainer(
          onTap: () {
            onClickClose();
          },
          width: 28.w,
          height: 25.w,
          child: Center(
            child: AppLocalImage(
              path: AppResource().close,
              width: 7.w,
              height: 7.w,
            ),
          ),
        )
      ],
    );
  }
}
