import 'package:youyu/config/theme.dart';
import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/modules/index/widget/index_page_widget.dart';
import 'package:youyu/modules/primary/discover/index/sub/discover_sub_list_view.dart';
import 'package:youyu/modules/primary/discover/index/widget/discover_tab_bar.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/button/app_image_button.dart';
import 'package:youyu/widgets/app/icon/app_un_read_icon.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/widgets/top_bg/top_ba.dart';
import 'discover_index_logic.dart';
import 'package:youyu/widgets/page_life_state.dart';

class DiscoverIndexPage extends IndexWidget {
  const DiscoverIndexPage({Key? key}) : super(key: key);

  @override
  State<DiscoverIndexPage> createState() => _DiscoverIndexPageState();

  @override
  void onTabTap({param}) {}
}

class _DiscoverIndexPageState extends PageLifeState<DiscoverIndexPage>
    with AutomaticKeepAliveClientMixin {
  final logic = Get.find<DiscoverIndexLogic>();
  final GlobalKey<DiscoverTabBarState> tabBarKey =
      GlobalKey<DiscoverTabBarState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppPage<DiscoverIndexLogic>(
      topBg: const TopBgCommon(),
      backgroundColor: AppTheme.colorPinkWhiteBg,
      appBar: DiscoverTabBar(
        logic: logic,
        key: tabBarKey,
        rightAction: AppRow(
          children: [
            AppStack(
              onTap: () {
                logic.onClickNotification();
              },
              alignment: Alignment.center,
              height: 25.h,
              children: [
                SizedBox(
                  width: 52.w,
                  height: ScreenUtils.navbarHeight,
                ),
                AppLocalImage(path: AppResource().disNotify, width: 18.w),
                Positioned(
                  top: 0,
                  right: 3.5.w,
                  child: Obx(() => AppUnReadIcon(
                        number: logic.unReadNum.value,
                        fontSize: 8.sp,
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.h),
                      )),
                )
              ],
            ),
            SizedBox(
              width: 2.w,
            ),
            AppImageButton(
                path: AppResource().disAdd,
                width: 18.w,
                onClick: () {
                  logic.onClickAdd();
                }),
          ],
        ),
      ),
      childBuilder: (s) {
        return NotificationListener<ScrollNotification>(
          child: TabBarView(
              controller: logic.tabController,
              children: logic.tabs.map((e) {
                return DiscoverSubListPage(tabModel: e);
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

                tabBarKey.currentState?.updateIndex(index);
              }
            }
            return true;
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void onPagePause() {}

  @override
  void onPageResume() {}
}
