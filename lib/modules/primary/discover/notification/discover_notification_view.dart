import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/modules/primary/discover/notification/sub/discover_notification_sub_view.dart';
import 'package:youyu/modules/primary/discover/notification/widget/discover_notification_bar.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/icon/app_un_read_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'discover_notification_logic.dart';

class DiscoverNotificationPage extends StatelessWidget {
  DiscoverNotificationPage({Key? key}) : super(key: key);

  final GlobalKey<DiscoverNotificationTabBarState> tabBarKey =
      GlobalKey<DiscoverNotificationTabBarState>();
  final logic = Get.find<DiscoverNotificationLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<DiscoverNotificationLogic>(
      appBar: const AppTopBar(
        title: "动态消息",
      ),
      childBuilder: (s) {
        return AppColumn(
          padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 15.w),
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: DiscoverNotificationTabBar(
                tabs: logic.tabs,
                key: tabBarKey,
                tabController: logic.tabController,
                topWidget: AppRow(
                  children: [
                    Expanded(
                        child: AppContainer(
                      padding: EdgeInsets.only(right: 10.w),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: AppUnReadIcon(number: logic.commentUnRead),
                      ),
                    )),
                    Expanded(
                        child: AppContainer(
                      padding: EdgeInsets.only(right: 6.w),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: AppUnReadIcon(number: logic.atUnRead),
                      ),
                    )),
                    Expanded(
                        child: AppContainer(
                      padding: EdgeInsets.only(right: 10.w),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: AppUnReadIcon(number: logic.likeUnRead),
                      ),
                    )),
                  ],
                ),
              ),
            ),
            Expanded(
              child: _tabBarView(),
            )
          ],
        );
      },
    );
  }

  _tabBarView() {
    return NotificationListener<ScrollNotification>(
      child: TabBarView(
          controller: logic.tabController,
          children: logic.tabs.map((e) {
            return DiscoverNotificationSubPage(
              tabModel: e,
            );
          }).toList()),
      onNotification: (ScrollNotification scrollNotification) {
        // 监听实时更新，迅速动画，TabController监听有效的是ScrollEndNotification
        if (scrollNotification is ScrollUpdateNotification &&
            scrollNotification.depth == 0) {
          // 一般页面都是左右滚动
          if (scrollNotification.metrics.axisDirection == AxisDirection.right) {
            // 滚动百分比，0.0-1.0
            double progress = scrollNotification.metrics.pixels /
                scrollNotification.metrics.maxScrollExtent;
            double unit = 1.0 / logic.tabs.length;
            int index = progress ~/ unit;

            tabBarKey.currentState?.updateIndex(index);
          }
        }
        return true;
      },
    );
  }
}
