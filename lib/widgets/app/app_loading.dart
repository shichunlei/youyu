import 'package:youyu/utils/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:youyu/config/theme.dart';

///页面加载loading
class AppLoading extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final bool isCanTouch;
  final bool hasNavBar;

  const AppLoading(
      {Key? key, required this.hasNavBar, this.margin, this.isCanTouch = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, size) {
        return isCanTouch ? Container(
          color: Colors.transparent,
          height: size.maxHeight,
          width: size.maxWidth,
          alignment: Alignment.topCenter,
          padding: margin ?? _defaultMargin(size),
          child: UnconstrainedBox(
            child: SpinKitRing(
              lineWidth: 2.5,
              size: 45.w,
              duration: const Duration(milliseconds: 1000),
              color: AppTheme.colorMain,
            ),
          ),
        ) : Container(
          color: Colors.transparent,
          height: size.maxHeight,
          width: size.maxWidth,
          alignment: Alignment.topCenter,
          padding: margin ?? EdgeInsets.only(top: size.maxHeight * 0.42),
          child: UnconstrainedBox(
            child: SpinKitRing(
              lineWidth: 2.5,
              size: 45.w,
              duration: const Duration(milliseconds: 1000),
              color: AppTheme.colorMain,
            ),
          ),
        );
      },
    );
  }

  EdgeInsets _defaultMargin(size) {
    if (hasNavBar) {
      return EdgeInsets.only(
          top: ScreenUtils.screenHeight * 0.42 - ScreenUtils.statusBarHeight);
    } else {
      return EdgeInsets.only(top: size.maxHeight * 0.42);
    }
  }
}
