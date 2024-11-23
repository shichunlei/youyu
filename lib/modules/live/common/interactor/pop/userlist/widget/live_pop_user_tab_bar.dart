import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:youyu/config/theme.dart';



class LivePopUserTabBar extends StatefulWidget {
  const LivePopUserTabBar(
      {super.key, required this.tabs, required this.controller});

  final List<TabModel> tabs;
  final TabController controller;

  @override
  State<LivePopUserTabBar> createState() => LivePopUserTabBarState();
}

class LivePopUserTabBarState extends State<LivePopUserTabBar> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(AppTheme().indicatorImage, context);
    return Container(
      margin: EdgeInsets.only(top: 15.h, bottom: 5.h),
      padding: EdgeInsets.only(left: 12.w, right: 12.w),
      width: double.infinity,
      height: 38.h,
      child: TabBar(
        dividerColor: Colors.transparent,
        automaticIndicatorColorAdjustment: false,
        tabs: widget.tabs.map((e) {
          return Tab(text: e.name);
        }).toList(),
        padding: EdgeInsets.zero,
        labelPadding: EdgeInsets.zero,
        indicator: BoxDecoration(
            image: DecorationImage(
                image: AppTheme().indicatorImage, fit: BoxFit.contain)),
        indicatorPadding: EdgeInsets.only(top: 33.h),
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: TextStyle(
          color: AppTheme.colorTextSecond,
          fontSize: 14.sp,
        ),
        unselectedLabelStyle: TextStyle(
          color: AppTheme.colorTextWhite,
          fontSize: 14.sp,
        ),
        controller: widget.controller,
        isScrollable: false,
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
}
