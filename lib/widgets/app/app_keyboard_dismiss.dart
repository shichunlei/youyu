import 'package:flutter/material.dart';

///关闭键盘
class AppKeyboardDismiss extends StatelessWidget {
  const AppKeyboardDismiss({
    Key? key,
    this.child,
  }) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: child,
    );
  }
}
