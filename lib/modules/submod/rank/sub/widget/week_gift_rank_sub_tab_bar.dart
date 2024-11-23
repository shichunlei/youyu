import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:youyu/config/theme.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';

class WeekGiftRankSubTabBar extends StatefulWidget {
  const WeekGiftRankSubTabBar(
      {super.key, required this.tabs, required this.controller});

  final List<TabModel> tabs;
  final TabController controller;

  @override
  State<WeekGiftRankSubTabBar> createState() => WeekGiftRankSubTabBarState();
}

class WeekGiftRankSubTabBarState extends State<WeekGiftRankSubTabBar> {
  final _currentIndex = 0.obs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(AppTheme().indicatorImage, context);
    return SizedBox(
      width: double.infinity,
      height: 73.h,
      child: TabBar(
        dividerColor: Colors.transparent,
        automaticIndicatorColorAdjustment: false,
        tabs: widget.tabs.mapIndexed((index, e) {
          return Obx(() => Tab(
              height: 73.h,
              child: AppColumn(
                mainAxisAlignment: MainAxisAlignment.center,
                strokeWidth: 1.w,
                radius: 8.w,
                gradient: index == _currentIndex.value
                    ? AppTheme().btnGradient
                    : null,
                strokeColor: index == _currentIndex.value
                    ? Colors.transparent
                    : AppTheme.colorMain,
                children: [
                  AppNetImage(
                    width: double.infinity,
                    height: 33.h,
                    imageUrl: widget.tabs[index].image,
                    fit: BoxFit.contain,
                    defaultWidget: const SizedBox.shrink(),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    widget.tabs[index].name,
                    style: AppTheme().textStyle(
                        fontSize: 11.sp, color: AppTheme.colorTextWhite),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                ],
              )));
        }).toList(),
        labelPadding: EdgeInsets.symmetric(horizontal: 4.5.w), // 调整水平间距
        indicatorColor: Colors.transparent,
        controller: widget.controller,
        isScrollable: false,
        dragStartBehavior: DragStartBehavior.start,
      ),
    );
  }

  updateIndex(int index) {
    if (index != _currentIndex.value && index < widget.tabs.length) {
      _currentIndex.value = index;
    }
  }
}
