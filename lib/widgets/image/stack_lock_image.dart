import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:flutter/material.dart';


class StackLockImage extends StatelessWidget {
  const StackLockImage(
      {super.key,
      required this.imageUrl,
      required this.isLock,
      this.borderRadius,
      this.width,
      this.height,
      this.lockHeight,
      this.lockWidth});

  final String imageUrl;
  final bool isLock;
  final double? width;
  final double? height;
  final double? lockWidth;
  final double? lockHeight;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return AppStack(
      decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(10.w)),
      alignment: Alignment.center,
      children: [
        AppNetImage(
          imageUrl: imageUrl,
          width: width ?? double.infinity,
          height: height,
          fit: BoxFit.cover,
        ),
        if (isLock)
          AppLocalImage(
            path: AppResource().homeLock,
            width: lockWidth ?? 64.w,
            height: lockHeight ?? 64.w,
          )
      ],
    );
  }
}
