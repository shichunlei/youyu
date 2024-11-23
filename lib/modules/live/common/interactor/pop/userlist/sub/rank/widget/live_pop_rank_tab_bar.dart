import 'package:youyu/utils/platform_utils.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/config/theme.dart';

import 'package:collection/collection.dart';

class LivePopRankTabBar extends StatefulWidget {
  const LivePopRankTabBar(
      {super.key, required this.tabs, required this.controller});

  final List<TabModel> tabs;
  final TabController controller;

  @override
  State<LivePopRankTabBar> createState() => LivePopRankTabBarState();
}

class LivePopRankTabBarState extends State<LivePopRankTabBar> {
  final _currentIndex = 0.obs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(AppTheme().indicatorImage, context);
    return Container(
      padding: EdgeInsets.only(left: 50.w, right: 50.w),
      width: double.infinity,
      height: 40.h,
      child: TabBar(
        dividerColor: Colors.transparent,
        automaticIndicatorColorAdjustment: false,
        tabs: widget.tabs.mapIndexed((index, e) {
          return Obx(() => Tab(
                child: Container(
                  width: 64.w,
                  height: 24.h,
                  alignment: Alignment.center,
                  decoration: (index == _currentIndex.value)
                      ? selState()
                      : normalState(),
                  child: Center(
                    child: Text(
                      e.name,
                      style: AppTheme().textStyle(
                          fontSize: 14.sp,
                          color: AppTheme.colorTextWhite),
                    ),
                  ),
                ),
              ));
        }).toList(),
        indicatorColor: Colors.transparent,
        controller: widget.controller,
        isScrollable: false,
        dragStartBehavior: DragStartBehavior.start,
      ),
    );
  }

  selState() {
    return BoxDecoration(
        gradient: AppTheme().btnGradient,
        borderRadius: BorderRadius.circular(20.h));
  }

  normalState() {
    return BoxDecoration(
        color: const Color(0xFf283110),
        border: PlatformUtils.isAndroid
            ? null
            : Border.all(width: 1, color: const Color(0xFF2A5200)),
        borderRadius: BorderRadius.circular(20.h));
  }

  updateIndex(int index) {
    if (index != _currentIndex.value && index < widget.tabs.length) {
      _currentIndex.value = index;
    }
  }
}
