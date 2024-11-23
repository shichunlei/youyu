import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:youyu/config/theme.dart';

class AppNetImage extends StatelessWidget {
  const AppNetImage(
      {Key? key,
      this.imageUrl,
      this.fit,
      this.width,
      this.height,
      this.cacheSize = 1080,
      this.canScale = false,
      this.defaultWidget,
      this.errorWidget,
      this.radius,
      this.onTap,
      this.alignment,
      this.fadeInDuration,
      this.fadeOutDuration})
      : super(key: key);
  final String? imageUrl;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final int cacheSize;
  final bool canScale;
  final Widget? defaultWidget;
  final Widget? errorWidget;
  final BorderRadius? radius;
  final GestureTapCallback? onTap;
  final Alignment? alignment;
  final Duration? fadeInDuration;
  final Duration? fadeOutDuration;

  @override
  Widget build(BuildContext context) {
    String url = imageUrl ?? '';
    Widget img = defaultWidget ??
        AppTheme().defaultImage(width: width, height: height);
    if (url.isNotEmpty) {
      img = ClipRRect(
        borderRadius: radius ?? BorderRadius.zero,
        child: CachedNetworkImage(
          imageUrl: url,
          width: width,
          height: height,
          alignment: alignment ?? Alignment.center,
          fit: fit,
          fadeOutDuration: fadeOutDuration ?? const Duration(milliseconds: 800),
          fadeInDuration: fadeInDuration ?? const Duration(milliseconds: 300),
          memCacheWidth: cacheSize,
          placeholder: (context, url) =>
              defaultWidget ??
              AppTheme().defaultImage(width: width, height: height),
          errorWidget: (context, url, error) =>
              errorWidget ??
              const Center(
                child: Icon(Icons.error),
              ),
        ),
      );
    }
    return GestureDetector(
      onTap: onTap,
      child: img,
    );
  }
}
