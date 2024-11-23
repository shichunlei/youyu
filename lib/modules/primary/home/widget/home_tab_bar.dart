import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/primary/home/home_index_logic.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/button/app_image_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';

class HomeTabBar extends StatefulWidget implements PreferredSizeWidget {
  const HomeTabBar(
      {super.key,
      required this.extraHeight,
      required this.extraWidget,
      required this.onClickRank,
      required this.onClickCreate,
      this.onTap,
      required this.logic});

  final HomeIndexLogic logic;
  final ValueChanged<int>? onTap;
  final double extraHeight;
  final Widget extraWidget;

  //点击排行榜
  final Function onClickRank;

  //点击创建直播间
  final Function onClickCreate;

  @override
  State<HomeTabBar> createState() => HomeTabBarState();

  @override
  Size get preferredSize =>
      Size.fromHeight(ScreenUtils.navbarHeight + extraHeight);
}

class HomeTabBarState extends State<HomeTabBar> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(AppTheme().indicatorImage, context);
    return SafeArea(
        child: Container(
      padding: EdgeInsets.only(left: 14.w, right: 14.w),
      color: AppTheme.colorNavBar,
      width: double.infinity,
      height: widget.preferredSize.height,
      child: Obx(() {
        if (widget.logic.tabs.isNotEmpty) {
          return AppColumn(
            height: widget.preferredSize.height,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppRow(
                height: ScreenUtils.navbarHeight,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: TabBar(
                    tabAlignment: TabAlignment.start,
                    onTap: (int index) {
                      if (widget.onTap != null) {
                        widget.onTap!(index);
                      }
                    },
                    dividerColor:Colors.transparent,
                    automaticIndicatorColorAdjustment: false,
                    tabs: widget.logic.tabs.mapIndexed((index, e) {
                      return _animatedTab(index, e.name);
                    }).toList(),
                    padding: EdgeInsets.zero,
                    labelPadding: EdgeInsets.only(right: 20.w),
                    indicator: BoxDecoration(
                        image: DecorationImage(
                            image: AppTheme().indicatorImage,
                            fit: BoxFit.contain)),
                    indicatorPadding: EdgeInsets.only(top: 30.h),
                    indicatorSize: TabBarIndicatorSize.label,
                    controller: widget.logic.homeTabController,
                    isScrollable: true,
                    dragStartBehavior: DragStartBehavior.start,
                  )),
                  Row(
                    children: [
                      AppImageButton(
                          path: AppResource().homeRankLogo,
                          width: 28.w,
                          onClick: widget.onClickRank),
                      SizedBox(
                        width: 17.w,
                      ),
                      AppImageButton(
                          path: AppResource().homeLiveCreateLogo,
                          width: 28.w,
                          onClick: widget.onClickCreate)
                    ],
                  )
                ],
              ),
              widget.extraWidget
            ],
          );
        }
        return Container();
      }),
    ));
  }

  updateIndex(int index) {
    if (index != _currentIndex && index < widget.logic.tabs.length) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  Widget _animatedTab(int index, String text) {
    TextStyle normalStyle = TextStyle(
      color: AppTheme.colorTextDark,
      fontSize: 16.sp,
    );
    TextStyle selectedStyle = TextStyle(
      color: AppTheme.colorTextWhite,
      fontSize: 22.sp,
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
