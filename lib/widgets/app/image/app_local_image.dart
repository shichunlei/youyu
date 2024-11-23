import 'package:flutter/material.dart';

class AppLocalImage extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? radius;
  final GestureTapCallback? onTap;
  final Color? imageColor;

  const AppLocalImage({
    Key? key,
    required this.path,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
    this.radius,
    this.onTap, this.imageColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radius ?? const BorderRadius.all(Radius.zero),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: width,
          height: height,
          child: Image.asset(
            path,
            fit: fit,
            color: imageColor,
          ),
        ),
      ),
    );
  }
}
