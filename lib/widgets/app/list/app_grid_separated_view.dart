import 'dart:async';
import 'package:youyu/utils/platform_utils.dart';
import 'package:youyu/widgets/app/app_default.dart';
import 'package:flutter/material.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AppGridSeparatedView extends StatelessWidget {
  const AppGridSeparatedView(
      {Key? key,
      required this.itemCount,
      required this.controller,
      required this.itemBuilder,
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
      required this.crossAxisCount,
      required this.mainAxisSpacing,
      required this.crossAxisSpacing,
      required this.childAspectRatio})
      : super(key: key);

  final int itemCount;
  final EdgeInsetsGeometry? padding;
  final RefreshController controller;
  final FutureOr<dynamic> Function()? onLoad;
  final FutureOr<dynamic> Function()? onRefresh;
  final Widget Function(BuildContext, int) itemBuilder;
  final Widget? footer;
  final Widget? header;
  final bool shrinkWrap;

  //默认页面配置
  final AppDefaultConfig? defaultConfig;

  bool get isEmpty => itemCount == 0;
  final bool isOpenLoadMore;
  final bool isOpenRefresh;

  final bool isNoData;

  /// The number of children in the cross axis.
  final int crossAxisCount;

  /// The number of logical pixels between each child along the main axis.
  final double mainAxisSpacing;

  /// The number of logical pixels between each child along the cross axis.
  final double crossAxisSpacing;

  /// The ratio of the cross-axis to the main-axis extent of each child.
  final double childAspectRatio;

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
    return GridView.builder(
        shrinkWrap: shrinkWrap,
        padding: padding ?? EdgeInsets.zero,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //水平子Widget之间间距
          crossAxisSpacing: crossAxisSpacing,
          //垂直子Widget之间间距
          mainAxisSpacing: mainAxisSpacing,
          //一行的Widget数量
          crossAxisCount: crossAxisCount,
          //子Widget宽高比例
          childAspectRatio: childAspectRatio,
        ));
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
