import 'package:youyu/modules/primary/home/list/type/home_type_sub_list_view.dart';
import 'package:youyu/utils/screen_utils.dart';

// import 'package:youyu/widgets/search/search_input_widget.dart';
import 'package:youyu/modules/index/widget/index_page_widget.dart';
import 'package:youyu/modules/primary/home/list/recommend/recommend_list_view.dart';
import 'package:youyu/modules/primary/home/widget/home_tab_bar.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/widgets/top_bg/top_ba.dart';
import 'home_index_logic.dart';
import 'package:youyu/widgets/page_life_state.dart';

class HomeIndexPage extends IndexWidget {
  const HomeIndexPage({Key? key}) : super(key: key);

  @override
  State<HomeIndexPage> createState() => _HomeIndexPageState();

  @override
  void onTabTap({param}) {}
}

class _HomeIndexPageState extends PageLifeState<HomeIndexPage>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<HomeTabBarState> tabBarKey = GlobalKey<HomeTabBarState>();
  final logic = Get.find<HomeIndexLogic>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppPage<HomeIndexLogic>(
      topBg: const TopBgCommon(),
      backgroundColor: Colors.transparent,
      appBar: HomeTabBar(
        logic: logic,
        key: tabBarKey,
        extraHeight: 0.h,
        // extraWidget: Container(
        //   padding: EdgeInsets.only(top: 8.h, bottom: 0.5.h),
        //   child: Center(
        //     child: SearchInputWidget(
        //       height: 38.h,
        //       placeHolder: '搜索房间名称，用户昵称或ID',
        //       enabled: false,
        //       onClick: () {
        //         //点击搜索
        //         logic.onClickSearch();
        //       },
        //     ),
        //   ),
        // ),
        onClickRank: () {
          //点击排行榜
          logic.onClickRank();
        },
        onClickCreate: () {
          //点击创建直播间
          logic.onClickCreate();
        },
        onClickSearch: () {
          // 点击搜索
          logic.onClickSearch();
        },
      ),
      childBuilder: (s) {
        return NotificationListener<ScrollNotification>(
          child: TabBarView(
              controller: logic.homeTabController,
              children: logic.tabs.map((e) {
                if (e.id == 0) {
                  //推荐
                  return RecommendListPage(
                    changeTabIndex: logic.changeTabIndex,
                  );
                }
                return HomeTypeSubListPage(key: UniqueKey(), tabModel: e);
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
