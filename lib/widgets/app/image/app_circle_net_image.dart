import 'package:youyu/utils/screen_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:youyu/config/theme.dart';

class AppCircleNetImage extends StatelessWidget {
  const AppCircleNetImage(
      {Key? key,
      this.imageUrl,
      this.size,
      this.cacheSize = 1080,
      this.borderColor,
      this.borderWidth,
      this.errorSize,
      this.defaultWidget,
      this.onTap})
      : super(key: key);

  //url
  final String? imageUrl;

  //大小
  final double? size;

  //缓存大小
  final int cacheSize;

  //默认图
  final Widget? defaultWidget;

  //边框宽
  final double? borderWidth;

  //边框颜色
  final Color? borderColor;

  //失败图大小
  final double? errorSize;

  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ScreenUtils.screenWidth),
          border: Border.all(
            width: borderWidth ?? 0,
            color: borderColor ?? Colors.transparent,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ScreenUtils.screenWidth),
          child: CachedNetworkImage(
            imageUrl: imageUrl ?? "",
            width: size,
            height: size,
            fit: BoxFit.cover,
            memCacheWidth: cacheSize,
            placeholder: (context, url) =>
                defaultWidget ??
                AppTheme().defaultImage(width: size, height: size),
            errorWidget: (context, url, error) => Container(
              color: AppTheme.colorBg,
              child: Icon(
                Icons.error,
                color: AppTheme.colorMain,
                size: errorSize ?? 25.w,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
