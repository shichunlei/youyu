import 'package:youyu/utils/screen_utils.dart';

import 'package:flutter/material.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';

class AppMoreIcon extends StatelessWidget {
  const AppMoreIcon(
      {super.key,
      this.title,
      this.image,
      required this.height,
      this.isShowText = true,
      this.imageWidth,
      this.imageColor,
      this.textColor,
      this.onTap,
      this.fontSize});

  final double height;
  final String? image;
  final String? title;
  final double? imageWidth;
  final double? fontSize;
  final bool isShowText;
  final Color? textColor;
  final Color? imageColor;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isShowText)
              Flexible(
                  child: Text(
                title ?? "更多",
                maxLines: 1,
                style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: textColor ?? AppTheme.colorTextSecond,
                    fontSize: fontSize ?? 12.sp),
              )),
            if (isShowText)
              const SizedBox(
                width: 6,
              ),
            Image(
              image: AssetImage(image ?? AppResource().arrow2),
              width: imageWidth ?? 5.w,
              fit: BoxFit.fitHeight,
              color: imageColor,
            ),
          ],
        ),
      ),
    );
  }
}
