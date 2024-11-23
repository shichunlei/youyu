import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/app/app_default.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/widgets/app/app_loading.dart';

//页面类型
enum AppLoadType { none, error, empty, success }

typedef AppPageBuilder<T extends AppBaseController> = Widget Function(
    T controller);

class AppPage<T extends AppBaseController> extends StatelessWidget {
  const AppPage({
    Key? key,
    this.child,
    this.loadingMargin,
    this.appBar,
    this.tag,
    this.childBuilder,
    this.backgroundColor,
    this.isLoadingCanTouch = false,
    this.resizeToAvoidBottomInset,
    this.uiOverlayStyle = SystemUiOverlayStyle.light,
    this.bottomBar,
    this.isUseScaffold = true,
    this.bodyHeight,
  }) : super(key: key);

  //导航栏
  final PreferredSizeWidget? appBar;

  final Widget? bottomBar;

  //控制器标识
  final String? tag;

  //页面内容(静态内容)
  final Widget? child;

  //页面内容(动态内容)
  final AppPageBuilder<T>? childBuilder;

  //状体栏颜色
  final SystemUiOverlayStyle uiOverlayStyle;

  //背景颜色
  final Color? backgroundColor;

  //是否显示Loading可以点击
  final bool isLoadingCanTouch;

  //页面loading间距
  final EdgeInsetsGeometry? loadingMargin;

  final bool? resizeToAvoidBottomInset;

  final bool isUseScaffold;

  final double? bodyHeight;

  @override
  Widget build(BuildContext context) {
    if (isUseScaffold) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: uiOverlayStyle,
        child: Scaffold(
            appBar: appBar,
            bottomNavigationBar: bottomBar,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            backgroundColor: backgroundColor ?? AppTheme.colorBg,
            body: _body()),
      );
    } else {
      return _body();
    }
  }

  _body() {
    return SizedBox(
      width: ScreenUtils.screenWidth,
      height: bodyHeight ?? ScreenUtils.screenHeight,
      child: Stack(
        children: <Widget>[
          _content(),
          _loading(),
        ],
      ),
    );
  }

  Widget _loading() {
    return GetBuilder<T>(
        id: GetxIds.loading,
        tag: tag,
        builder: (s) {
          return s.isLoading
              ? AppLoading(
                  hasNavBar: appBar != null,
                  margin: loadingMargin,
                  isCanTouch: isLoadingCanTouch)
              : Container();
        });
  }

  Widget _content() {
    return GetBuilder<T>(
        id: GetxIds.page,
        tag: tag,
        builder: (s) {
          switch (s.loadType) {
            case AppLoadType.none:
              return Container(
                color: backgroundColor ?? AppTheme.colorBg,
              );
            case AppLoadType.empty:
            case AppLoadType.error:
              return AppDefault(
                  loadType: s.loadType,
                  config: s.pageDefaultConfig,
                  reload: s.reLoadData);
            default:
              if (childBuilder != null) {
                return childBuilder!(s);
              } else {
                return child ?? const SizedBox();
              }
          }
        });
  }
}
