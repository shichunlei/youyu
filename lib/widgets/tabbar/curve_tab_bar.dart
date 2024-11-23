
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:youyu/config/theme.dart';

class CurveTabBar extends StatelessWidget {
  const CurveTabBar(
      {super.key,
      required this.tabs,
      required this.tabController,
      this.fontSize,
      this.labelPadding,
      this.indicatorPadding,
      required this.isScrollable});

  final List<TabModel> tabs;
  final TabController tabController;
  final double? fontSize;
  final EdgeInsets? labelPadding;
  final EdgeInsets? indicatorPadding;
  final bool isScrollable;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      dividerColor: Colors.transparent,
      onTap: (int index) {},
      automaticIndicatorColorAdjustment: false,
      tabs: tabs.map((e) {
        return Tab(text: e.name);
      }).toList(),
      padding: EdgeInsets.zero,
      labelColor: AppTheme.colorTextWhite,
      unselectedLabelColor: AppTheme.colorTextSecond,
      labelStyle: AppTheme().textStyle(fontSize: fontSize, color: AppTheme.colorTextWhite),
      unselectedLabelStyle: AppTheme().textStyle(
          fontSize: fontSize, color: AppTheme.colorTextSecond),
      labelPadding: labelPadding,
      indicator: BoxDecoration(
          image: DecorationImage(
              image: AppTheme().indicatorImage, fit: BoxFit.contain)),
      indicatorPadding: indicatorPadding ?? EdgeInsets.zero,
      indicatorSize: TabBarIndicatorSize.label,
      controller: tabController,
      isScrollable: isScrollable,
      dragStartBehavior: DragStartBehavior.start,
    );
  }
}
