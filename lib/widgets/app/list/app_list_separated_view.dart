import 'dart:async';
import 'package:youyu/utils/platform_utils.dart';
import 'package:youyu/widgets/app/app_default.dart';
import 'package:flutter/material.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AppListSeparatedView extends StatelessWidget {
  const AppListSeparatedView(
      {Key? key,
      required this.itemCount,
      required this.controller,
      required this.itemBuilder,
      required this.separatorBuilder,
      this.onLoad,
      this.padding,
      this.isOpenLoadMore = false,
      this.isOpenRefresh = true,
      this.defaultConfig,
      this.onRefresh,
      this.header,
      this.footer,
      this.shrinkWrap = false,
      this.isNoData = false,
      this.physics,
      this.listViewKey})
      : super(key: key);

  final int itemCount;
  final EdgeInsetsGeometry? padding;
  final RefreshController controller;
  final FutureOr<dynamic> Function()? onLoad;
  final FutureOr<dynamic> Function()? onRefresh;
  final Widget Function(BuildContext, int) itemBuilder;
  final Widget Function(BuildContext, int) separatorBuilder;
  final Widget? footer;
  final Widget? header;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  //默认页面配置
  final AppDefaultConfig? defaultConfig;

  bool get isEmpty => itemCount == 0;
  final bool isOpenLoadMore;
  final bool isOpenRefresh;

  final bool isNoData;

  final Key? listViewKey;

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      onLoading: onLoad,
      enablePullDown: isOpenRefresh,
      enablePullUp: !isEmpty && isOpenLoadMore,
      onRefresh: onRefresh,
      controller: controller,
      header: header ?? _defaultHeader(),
      footer: footer,
      child: isNoData
          ? AppDefault(loadType: AppLoadType.empty, config: defaultConfig)
          : _buildList(),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      key: listViewKey,
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding ?? EdgeInsets.zero,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      separatorBuilder: separatorBuilder,
    );
  }

  _defaultHeader() {
    if (PlatformUtils.isIOS) {
      return const ClassicHeader(
          refreshingText: "刷新中...",
          idleText: "下拉刷新",
          releaseText: "松开刷新",
          completeText: "刷新成功",
          failedText: "刷新失败");
    } else {
      return const MaterialClassicHeader(
        semanticsLabel: "刷新中",
      );
    }
  }
}
