import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/widgets/tabbar/curve_tab_bar.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:flutter/material.dart';

class UserDetailTabBar extends StatelessWidget implements PreferredSizeWidget {
  const UserDetailTabBar(
      {super.key, required this.tabs, required this.tabController});

  final List<TabModel> tabs;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      width: double.infinity,
      topLeftRadius: 10.w,
      topRightRadius: 10.w,
      padding: EdgeInsets.only(bottom: 10.h),
      color: AppTheme.colorBg,
      height: 54.h,
      alignment: Alignment.topLeft,
      child: CurveTabBar(
        tabs: tabs,
        fontSize: 18.sp,
        tabController: tabController,
        labelPadding: EdgeInsets.only(left: 17.w, right: 17.w),
        indicatorPadding: EdgeInsets.only(top: 28.h, left: 2.w, right: 2.w),
        isScrollable: true,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50.h);
}
