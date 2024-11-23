import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class DiscoverNotificationTabBar extends StatefulWidget
    implements PreferredSizeWidget {
  const DiscoverNotificationTabBar(
      {super.key,
      this.onTap,
      required this.tabs,
      required this.tabController,
      required this.topWidget});

  final TabController tabController;
  final List<TabModel> tabs;
  final ValueChanged<int>? onTap;
  final Widget topWidget;

  @override
  State<DiscoverNotificationTabBar> createState() =>
      DiscoverNotificationTabBarState();

  @override
  Size get preferredSize => Size.fromHeight(60.h);
}

class DiscoverNotificationTabBarState
    extends State<DiscoverNotificationTabBar> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(AppTheme().indicatorImage, context);
    return AppStack(
      alignment: Alignment.center,
      width: double.infinity,
      height: widget.preferredSize.height,
      children: [
        widget.topWidget,
        TabBar(
          dividerColor: Colors.transparent,
          onTap: (int index) {
            if (widget.onTap != null) {
              widget.onTap!(index);
            }
          },
          automaticIndicatorColorAdjustment: false,
          tabs: widget.tabs.mapIndexed((index, e) {
            return _animatedTab(index, e.name);
          }).toList(),
          padding: EdgeInsets.zero,
          indicator: BoxDecoration(
              image: DecorationImage(
                  image: AppTheme().indicatorImage, fit: BoxFit.contain)),
          indicatorPadding: EdgeInsets.only(top: 25.h),
          indicatorSize: TabBarIndicatorSize.label,
          controller: widget.tabController,
          isScrollable: false,
          dragStartBehavior: DragStartBehavior.start,
        )
      ],
    );
  }

  updateIndex(int index) {
    if (index != _currentIndex && index < widget.tabs.length) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  Widget _animatedTab(int index, String text) {
    TextStyle normalStyle = TextStyle(
      color: AppTheme.colorTextDark,
      fontSize: 15.sp,
    );
    TextStyle selectedStyle = TextStyle(
      color: AppTheme.colorTextWhite,
      fontSize: 15.sp,
    );
    return Tab(
      child: AnimatedDefaultTextStyle(
        style: _currentIndex == index ? selectedStyle : normalStyle,
        duration: const Duration(milliseconds: 90),
        child: Text(text),
      ),
    );
  }
}
