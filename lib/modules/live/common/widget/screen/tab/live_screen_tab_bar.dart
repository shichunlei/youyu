import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';

class LiveScreenTabBar extends StatefulWidget {
  const LiveScreenTabBar(
      {super.key, required this.tabs, required this.controller});

  final List<TabModel> tabs;
  final TabController controller;

  @override
  State<LiveScreenTabBar> createState() => LiveScreenTabBarState();
}

class LiveScreenTabBarState extends State<LiveScreenTabBar> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(AppTheme().indicatorImage, context);
    return Container(
      padding: EdgeInsets.only(left: 20.w,right: 20.w),
      width: double.infinity,
      height: 40.h,
      child: TabBar(
        tabAlignment: TabAlignment.start,
        dividerColor: Colors.transparent,
        automaticIndicatorColorAdjustment: false,
        tabs: widget.tabs.map((e) {
          return Tab(text: e.name);
        }).toList(),
        padding: EdgeInsets.zero,
        labelPadding: EdgeInsets.only(right: 22.w),
        indicator: BoxDecoration(
            image: DecorationImage(
                image: AppTheme().indicatorImage, fit: BoxFit.contain)),
        indicatorPadding: EdgeInsets.only(top: 30.h),
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: TextStyle(
            color: AppTheme.colorTextSecond,
            fontSize: 17.sp,
            fontFamily: AppResource().ys.name),
        unselectedLabelStyle: TextStyle(
            color: AppTheme.colorTextWhite,
            fontSize: 17.sp,
            fontFamily: AppResource().ys.name),
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

}
