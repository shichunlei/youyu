import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/submod/rank/sub/rank_sub_view.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'rank_index_logic.dart';
import 'package:collection/collection.dart';

class RankIndexPage extends StatelessWidget {
  RankIndexPage({Key? key, this.roomId}) : super(key: key);
  //目前用到不到，因为直播间里面的样式完全不一样了
  final String? roomId;
  final logic = Get.find<RankIndexLogic>();

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
        context: context,
        child: Stack(
          children: [
            ///底部背景
            Container(
              width: double.infinity,
              height: double.infinity,
              color: AppTheme.colorBg,
            ),

            ///顶部背景
            AppLocalImage(
              path: AppResource().rankTopBg,
              height: 361.h + ScreenUtils.navbarHeight,
              fit: BoxFit.cover,
            ),

            ///内容
            AppPage<RankIndexLogic>(
              backgroundColor: Colors.transparent,
              appBar: AppTopBar(
                backgroundColor: Colors.transparent,
                title: "全平台排行榜",
                extraHeight: 50.h,
                bottomWidget: _tabBar(),
              ),
              child: NotificationListener<ScrollNotification>(
                child: TabBarView(
                    controller: logic.tabController,
                    children: logic.tabs.map((e) {
                      return RankSubPage(
                        roomId: roomId,
                        tabModel: e,
                      );
                    }).toList()),
                onNotification: (ScrollNotification scrollNotification) {
                  // 监听实时更新，迅速动画，TabController监听有效的是ScrollEndNotification
                  if (scrollNotification is ScrollUpdateNotification &&
                      scrollNotification.depth == 0) {
                    // 一般页面都是左右滚动
                    if (scrollNotification.metrics.axisDirection ==
                        AxisDirection.right) {
                      // 滚动百分比，0.0-1.0
                      double progress = scrollNotification.metrics.pixels /
                          scrollNotification.metrics.maxScrollExtent;
                      double unit = 1.0 / logic.tabs.length;
                      int index = progress ~/ unit;
                      logic.updateIndex(index);
                    }
                  }
                  return true;
                },
              ),
            )
          ],
        ));
  }

  ///tabBar
  _tabBar() {
    return TabBar(
      dividerColor: Colors.transparent,
      tabAlignment: TabAlignment.start,
      // onTap: (int index) {},
      automaticIndicatorColorAdjustment: false,
      tabs: logic.tabs.mapIndexed((index, e) {
        return _animatedTab(index, e.name);
      }).toList(),
      padding: EdgeInsets.zero,
      labelColor: AppTheme.colorTextWhite,
      unselectedLabelColor: AppTheme.colorTextWhite,
      labelPadding: EdgeInsets.only(left: 17.w, right: 17.w),
      indicator: BoxDecoration(
          image: DecorationImage(
              image: AppTheme().indicatorImage, fit: BoxFit.contain)),
      indicatorPadding: EdgeInsets.only(top: 30.h, left: 2.w, right: 2.w),
      indicatorSize: TabBarIndicatorSize.label,
      controller: logic.tabController,
      isScrollable: true,
      dragStartBehavior: DragStartBehavior.start,
    );
  }

  Widget _animatedTab(int index, String text) {
    TextStyle normalStyle = TextStyle(
      color: AppTheme.colorTextWhite,
      fontSize: 16.sp,
    );
    TextStyle selectedStyle = TextStyle(
      color: AppTheme.colorTextWhite,
      fontSize: 20.sp,
    );
    return Obx(() => AppTheme().animatedTab(index, text, currentIndex: logic.currentIndex.value, normalStyle: normalStyle, selectedStyle: selectedStyle));
  }
}
