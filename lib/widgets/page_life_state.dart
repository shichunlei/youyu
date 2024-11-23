import 'package:flutter/material.dart';

///带有页面生命周期的State
abstract class PageLifeState<T extends StatefulWidget> extends State<T>
    with RouteAware {
  //页面监听
  static final RouteObserver<PageRoute> routeObserver =
  RouteObserver<PageRoute>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
  }

  @mustCallSuper
  @override
  void didPushNext() {
    super.didPushNext();
    onPagePause();
  }

  @mustCallSuper
  @override
  void didPopNext() {
    super.didPopNext();
    onPageResume();
  }

  //页面显示
  void onPageResume();

  //页面隐藏
  void onPagePause();
}