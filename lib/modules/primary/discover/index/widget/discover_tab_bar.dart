import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/primary/discover/index/discover_index_logic.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class DiscoverTabBar extends StatefulWidget implements PreferredSizeWidget {
  const DiscoverTabBar(
      {super.key, this.onTap, required this.logic, required this.rightAction});

  final DiscoverIndexLogic logic;
  final ValueChanged<int>? onTap;

  //widget
  final Widget rightAction;

  @override
  State<DiscoverTabBar> createState() => DiscoverTabBarState();

  @override
  Size get preferredSize => Size.fromHeight(ScreenUtils.navbarHeight);
}

class DiscoverTabBarState extends State<DiscoverTabBar> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(AppTheme().indicatorImage, context);
    return SafeArea(
        child: AppRow(
      padding: EdgeInsets.only(left: 14.w, right: 14.w),
      color: Colors.transparent,
      width: double.infinity,
      height: widget.preferredSize.height,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TabBar(
          tabAlignment: TabAlignment.start,
          dividerColor: Colors.transparent,
          onTap: (int index) {
            if (widget.onTap != null) {
              widget.onTap!(index);
            }
          },
          automaticIndicatorColorAdjustment: false,
          tabs: widget.logic.tabs.mapIndexed((index, e) {
            return _animatedTab(index, e.name);
          }).toList(),
          padding: EdgeInsets.zero,
          labelPadding: EdgeInsets.only(right: 20.w),
          indicator: BoxDecoration(
              image: DecorationImage(
                  image: AppTheme().indicatorImage, fit: BoxFit.contain)),
          indicatorPadding: EdgeInsets.only(top: 30.h),
          indicatorSize: TabBarIndicatorSize.label,
          controller: widget.logic.tabController,
          isScrollable: true,
          dragStartBehavior: DragStartBehavior.start,
        ),
        widget.rightAction
      ],
    ));
  }

  updateIndex(int index) {
    if (index != _currentIndex && index < widget.logic.tabs.length) {
      setState(() {
        _currentIndex = index;
      });
    }
  }
  // return Tab(text: e.name,);
  Widget _animatedTab(int index, String text) {
    TextStyle normalStyle = TextStyle(
      color: AppTheme.colorTextDark,
      fontSize: 16.sp,
    );
    TextStyle selectedStyle = TextStyle(
      color: AppTheme.colorTextDarkSecond,
      fontSize: 22.sp,
      fontWeight: FontWeight.w700,
    );
    return AppTheme().animatedTab(index, text, currentIndex: _currentIndex, normalStyle: normalStyle, selectedStyle: selectedStyle);

  }
}
