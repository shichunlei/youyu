import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/tabbar/curve_tab_bar.dart';
import 'package:youyu/modules/live/sub/blacklist/sub/live_setting_black_sub_view.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'live_setting_black_logic.dart';

class LiveSettingBlackPage extends StatelessWidget {
  LiveSettingBlackPage({Key? key}) : super(key: key);

  final logic = Get.find<LiveSettingBlackLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<LiveSettingBlackLogic>(
      appBar: const AppTopBar(
        title: "黑名单列表",
      ),
      childBuilder: (s) {
        return AppColumn(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 45.w),
              height: 58.h,
              child: CurveTabBar(
                tabs: logic.tabs,
                fontSize: 14.sp,
                tabController: logic.tabController,
                labelPadding: EdgeInsets.only(left: 8.w, right: 8.w),
                indicatorPadding:
                    EdgeInsets.only(top: 30.h, left: 2.w, right: 2.w),
                isScrollable: false,
              ),
            ),
            Expanded(
              child: TabBarView(
                  controller: logic.tabController,
                  children: logic.tabs.map((e) {
                    return LiveSettingBlackSubPage(
                      tabModel: e,
                      roomId: logic.roomId,
                      settingNotify: logic.settingNotify,
                    );
                  }).toList()),
            )
          ],
        );
      },
    );
  }
}
