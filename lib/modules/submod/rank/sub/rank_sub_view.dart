/*
 * @Author: alexalive hhyy1243047559@gmail.com
 * @Date: 2024-10-13 20:45:43
 * @LastEditors: alexalive hhyy1243047559@gmail.com
 * @LastEditTime: 2024-11-05 22:44:05
 * @FilePath: /youyu/lib/modules/submod/rank/sub/rank_sub_view.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/modules/submod/rank/list/rank_list_view.dart';
import 'package:youyu/modules/submod/rank/sub/widget/rank_sub_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/modules/submod/rank/sub/widget/week_gift_rank_sub_tab_bar.dart';
import 'rank_sub_logic.dart';

class RankSubPage extends StatefulWidget {
  const RankSubPage({Key? key, this.roomId, required this.tabModel})
      : super(key: key);
  final String? roomId;
  final TabModel tabModel;

  @override
  State<RankSubPage> createState() => _RankSubPageState();
}

class _RankSubPageState extends State<RankSubPage>
    with AutomaticKeepAliveClientMixin {
  late RankSubLogic logic =
      Get.find<RankSubLogic>(tag: widget.tabModel.id.toString());

  final GlobalKey<RankSubTabBarState> tabBarKey =
      GlobalKey<RankSubTabBarState>();

  final GlobalKey<WeekGiftRankSubTabBarState> weekGiftTabBarKey =
      GlobalKey<WeekGiftRankSubTabBarState>();

  @override
  void initState() {
    super.initState();
    Get.put<RankSubLogic>(RankSubLogic(), tag: widget.tabModel.id.toString());

    logic.dataModel = widget.tabModel;
    logic.tabController = TabController(
        length: widget.tabModel.id == 4 ? 4 : logic.tabs.length, vsync: logic);
    logic.tabController.addListener(updateIndex);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<void>(
        future: widget.tabModel.id == 4 ? logic.fetchWeekGiftData() : null,
        builder: (context, snapshot) {
          final List<TabModel> tabs =
              widget.tabModel.id == 4 ? logic.giftTabs : logic.tabs;
          return Column(
            children: [
              widget.tabModel.id == 4
                  ? WeekGiftRankSubTabBar(
                      key: weekGiftTabBarKey,
                      tabs: tabs,
                      controller: logic.tabController,
                    )
                  : RankSubTabBar(
                      key: tabBarKey,
                      tabs: tabs,
                      controller: logic.tabController,
                    ),
              Expanded(
                  child: Container(
                color: Colors.transparent,
                child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: logic.tabController,
                    children: tabs.map((e) {
                      return
                          // Container(
                          //   color: Colors.transparent,
                          // );
                          RankListPage(
                        roomId: widget.roomId,
                        mainTab: logic.dataModel,
                        subTab: e,
                      );
                    }).toList()),
              ))
            ],
          );
        });
  }

  updateIndex() {
    tabBarKey.currentState?.updateIndex(logic.tabController.index);
    weekGiftTabBarKey.currentState?.updateIndex(logic.tabController.index);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
    logic.tabController.removeListener(updateIndex);
  }
}
