import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:youyu/config/theme.dart';

class BagTabBar extends StatefulWidget {
  const BagTabBar({super.key, required this.tabs, required this.controller});

  final List<TabModel> tabs;
  final TabController controller;

  @override
  State<BagTabBar> createState() => BagTabBarState();
}

class BagTabBarState extends State<BagTabBar> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(AppTheme().indicatorImage, context);
    return Container(
      color: AppTheme.colorDarkBg,
      padding: EdgeInsets.only(top: 7.h),
      width: double.infinity,
      height: (38+7).h,
      child: TabBar(
        tabAlignment: TabAlignment.start,
        dividerColor: Colors.transparent,
        automaticIndicatorColorAdjustment: false,
        tabs: widget.tabs.mapIndexed((index, e) {
          return _animatedTab(index, e.name);
        }).toList(),
        padding: EdgeInsets.zero,
        labelPadding: EdgeInsets.symmetric(horizontal: 15.w),
        indicatorPadding: EdgeInsets.only(top: 33.h, left: 10.w, right: 10.w),
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: const Color(0xFF612ADA),
        controller: widget.controller,
        isScrollable: true,
        dragStartBehavior: DragStartBehavior.start,
      ),
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
      fontSize: 14.sp,
    );
    TextStyle selectedStyle = TextStyle(
      color: AppTheme.colorTextWhite,
      fontSize: 18.sp,
    );
    return AppTheme().animatedTab(index, text, currentIndex: _currentIndex, normalStyle: normalStyle, selectedStyle: selectedStyle);

  }
}
