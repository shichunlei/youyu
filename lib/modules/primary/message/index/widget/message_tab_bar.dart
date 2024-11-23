import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/primary/message/index/message_index_logic.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/button/app_image_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class MessageTabBar extends StatefulWidget implements PreferredSizeWidget {
  const MessageTabBar(
      {super.key,
      required this.onClickClearUnRead,
      this.onTap,
      required this.logic});

  final MessageIndexLogic logic;
  final ValueChanged<int>? onTap;

  //一键清除消息
  final Function onClickClearUnRead;

  @override
  State<MessageTabBar> createState() => MessageTabBarState();

  @override
  Size get preferredSize => Size.fromHeight(ScreenUtils.navbarHeight);
}

class MessageTabBarState extends State<MessageTabBar> {
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
      color: AppTheme.colorNavBar,
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
        AppImageButton(
            path: AppResource().msgUnreadClear,
            width: 18.w,
            onClick: widget.onClickClearUnRead),
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
