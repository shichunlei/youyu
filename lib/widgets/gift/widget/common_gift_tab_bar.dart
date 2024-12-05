import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:youyu/config/theme.dart';

class CommonGiftTabBar extends StatefulWidget {
  const CommonGiftTabBar({super.key, required this.tabs, this.controller, required this.height});

  final List<TabModel> tabs;
  final TabController? controller;
  final double height;

  @override
  State<CommonGiftTabBar> createState() => CommonGiftTabBarState();
}

class CommonGiftTabBarState extends State<CommonGiftTabBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: widget.height,
      child: TabBar(
        tabAlignment: TabAlignment.start,
        dividerColor: Colors.transparent,
        automaticIndicatorColorAdjustment: false,
        tabs: widget.tabs.map((e) {
          return Tab(text: e.name);
        }).toList(),
        padding: EdgeInsets.zero,
        labelPadding: EdgeInsets.only(right: 22.w),
        indicatorPadding: EdgeInsets.only(top: 30.h),
        indicatorColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: AppTheme.colorMain,
        unselectedLabelColor: AppTheme.colorTextSecond,
        labelStyle:
            TextStyle(color: AppTheme.colorMain, fontSize: 13.sp),
        unselectedLabelStyle:
            TextStyle(color: AppTheme.colorTextSecond, fontSize: 13.sp),
        controller: widget.controller,
        isScrollable: true,
        dragStartBehavior: DragStartBehavior.start,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
