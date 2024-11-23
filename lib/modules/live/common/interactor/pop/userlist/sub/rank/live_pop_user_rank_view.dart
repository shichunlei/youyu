import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/modules/live/common/interactor/pop/userlist/sub/rank/sub/live_pop_user_rank_sub_view.dart';
import 'package:youyu/modules/live/common/interactor/pop/userlist/sub/rank/widget/live_pop_rank_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'live_pop_user_rank_logic.dart';

class LivePopUserRankPage extends StatefulWidget {
  const LivePopUserRankPage({Key? key, required this.tabModel, required this.roomId})
      : super(key: key);
  final TabModel tabModel;
  final int roomId;

  @override
  State<LivePopUserRankPage> createState() => _LivePopUserRankPageState();
}

class _LivePopUserRankPageState extends State<LivePopUserRankPage>
    with AutomaticKeepAliveClientMixin {
  late LivePopUserRankLogic logic =
      Get.find<LivePopUserRankLogic>(tag: widget.tabModel.id.toString());

  final GlobalKey<LivePopRankTabBarState> tabBarKey =
      GlobalKey<LivePopRankTabBarState>();

  @override
  void initState() {
    super.initState();
    Get.put<LivePopUserRankLogic>(LivePopUserRankLogic(),
        tag: widget.tabModel.id.toString());
    logic.dataModel = widget.tabModel;
    logic.tabController =
        TabController(length: logic.tabs.length, vsync: logic);
    logic.tabController.addListener(updateIndex);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        LivePopRankTabBar(
          key: tabBarKey,
          tabs: logic.tabs,
          controller: logic.tabController,
        ),
        Expanded(
            child: Container(
          color: Colors.transparent,
          child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: logic.tabController,
              children: logic.tabs.map((e) {
                return LivePopUserRankSubPage(
                  roomId: widget.roomId,
                  mainTab: logic.dataModel,
                  subTab: e,
                );
              }).toList()),
        ))
      ],
    );
  }

  updateIndex() {
    tabBarKey.currentState?.updateIndex(logic.tabController.index);
  }

  @override
  bool get wantKeepAlive => true;
}
