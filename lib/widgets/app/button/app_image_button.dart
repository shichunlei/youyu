import 'package:flutter/material.dart';

class AppImageButton extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Function onClick;

  const AppImageButton({
    Key? key,
    required this.path,
    required this.onClick,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClick();
      },
      child: ClipRRect(
        borderRadius: borderRadius ?? const BorderRadius.all(Radius.zero),
        child: SizedBox(
          width: width,
          height: height,
          child: Image.asset(
            path,
            fit: fit,
          ),
        ),
      ),
    );
  }
}
