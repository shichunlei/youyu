import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///状态栏样式
class AppSystemStyle extends StatelessWidget {
  const AppSystemStyle({
    Key? key,
    required this.child,
    this.systemOverlayStyle,
    this.sized = true,
  }) : super(key: key);

  final bool sized;
  final Widget child;
  final SystemUiOverlayStyle? systemOverlayStyle;

  SystemUiOverlayStyle get value {
    const defaultStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.black,
    );

    return systemOverlayStyle ?? defaultStyle;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: value,
      sized: sized,
      child: child,
    );
  }
}
