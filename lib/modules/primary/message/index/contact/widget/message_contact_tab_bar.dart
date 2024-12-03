import 'package:youyu/utils/platform_utils.dart';
import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class MessageContactTabBar extends StatefulWidget {
  const MessageContactTabBar(
      {super.key,
      required this.tabs,
      required this.controller,
      required this.onClickTab});

  final List<TabModel> tabs;
  final TabController controller;
  final Function(int index) onClickTab;

  @override
  State<MessageContactTabBar> createState() => MessageContactState();
}

class MessageContactState extends State<MessageContactTabBar> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppRow(
      margin: EdgeInsets.only(left: 4.w),
      crossAxisAlignment: CrossAxisAlignment.center,
      alignment: Alignment.centerLeft,
      color: Colors.transparent,
      width: double.infinity,
      height: 44.h,
      children: widget.tabs.mapIndexed((index, e) {
        return _animatedTab(index, e.name);
      }).toList(),
    );
  }

  _updateIndex(int index) {
    if (index != _currentIndex && index < widget.tabs.length) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  Widget _animatedTab(int index, String text) {
    if (_currentIndex == index) {
      return AppContainer(
        width: 62.w,
        height: 24.h,
        radius: 99.h,
        gradient: AppTheme().btnGradient,
        margin: EdgeInsets.symmetric(horizontal: 10.sp),
        child: Center(
          child: Text(
            text,
            style: AppTheme()
                .textStyle(fontSize: 14.sp, color: AppTheme.colorTextWhite),
          ),
        ),
      );
    } else {
      return AppContainer(
        onTap: () {
          _updateIndex(index);
          widget.onClickTab(index);
        },
        width: 62.w,
        height: 24.h,
        margin: EdgeInsets.symmetric(horizontal: 10.sp),
        radius: 99.h,
        color: const Color(0xFFFFFFFF),
        strokeColor: PlatformUtils.isAndroid
            ? Colors.transparent
            : const Color(0xFF2A5200),
        strokeWidth: PlatformUtils.isAndroid ? 0 : 1,
        child: Center(
          child: Text(
            text,
            style: AppTheme()
                .textStyle(fontSize: 14.sp, color: AppTheme.colorTextSecond),
          ),
        ),
      );
    }
  }
}
