import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';

class WheelAniWidget extends StatelessWidget {
  const WheelAniWidget({super.key, this.margin, this.onTap});

  final EdgeInsetsGeometry? margin;

  final Function(bool isOpen)? onTap;

  @override
  Widget build(BuildContext context) {
    return AppStack(
      margin: margin,
      height: 23.w,
      width: 78.w,
      children: [
        Obx(() => AppLocalImage(
              path: LiveService().isWheelGameAniOpen.value
                  ? AppResource().gameWheelAniOpen
                  : AppResource().gameWheelAniClose,
              width: 78.w,
            )),
        AppRow(
          width: double.infinity,
          height: double.infinity,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: AppContainer(
              height: double.infinity,
              onTap: () {
                if (onTap != null) {
                  onTap!(true);
                }
              },
            )),
            Expanded(
                child: AppContainer(
              height: double.infinity,
              onTap: () {
                if (onTap != null) {
                  onTap!(false);
                }
              },
            )),
          ],
        )
      ],
    );
  }
}
