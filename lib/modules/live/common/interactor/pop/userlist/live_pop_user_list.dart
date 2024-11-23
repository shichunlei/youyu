import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/modules/live/common/interactor/pop/userlist/sub/online/live_pop_user_on_line_view.dart';
import 'package:youyu/modules/live/common/interactor/pop/userlist/sub/rank/live_pop_user_rank_view.dart';
import 'package:youyu/modules/live/common/interactor/pop/userlist/widget/live_pop_user_tab_bar.dart';
import 'package:youyu/widgets/app/app_round_container.dart';
import 'package:flutter/material.dart';

///用户列表
class LivePopUserList extends StatefulWidget {
  const LivePopUserList(
      {super.key,
      required this.onClickThreeListMore,
      required this.onlineUserList,
      required this.roomId,
      required this.isOwner,
      required this.position,
      required this.isManager});

  final int roomId;
  final bool isOwner;
  final bool isManager;
  final List<UserInfo> onlineUserList;
  final int position;
  final Function(int position, UserInfo userInfo) onClickThreeListMore;

  @override
  State<LivePopUserList> createState() => LivePopUserListState();
}

class LivePopUserListState extends State<LivePopUserList>
    with SingleTickerProviderStateMixin {
  ///tab
  late TabController tabController;
  List<TabModel> tabs = [];

  final GlobalKey<LivePopUserOnLinePageState> _popUserOnLineKey =
      GlobalKey<LivePopUserOnLinePageState>();

  @override
  void initState() {
    super.initState();
    tabs.addAll([
      TabModel(id: 0, name: "在线列表（${widget.onlineUserList.length}）"),
      TabModel(id: 2, name: "魅力榜"),
      TabModel(id: 1, name: "财富榜"),
    ]);
    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return AppRoundContainer(
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.w), topRight: Radius.circular(12.w)),
        bgColor: AppTheme.colorDarkBg,
        height: 588.h,
        child: Column(children: [
          LivePopUserTabBar(
            tabs: tabs,
            controller: tabController,
          ),
          SizedBox(
            height: 15.h,
          ),
          Expanded(
              child: Container(
                  color: Colors.transparent,
                  child: TabBarView(controller: tabController, children: [
                    LivePopUserOnLinePage(
                      key: _popUserOnLineKey,
                      tabModel: tabs[0],
                      roomId: widget.roomId,
                      onClickMore: (userInfo) {
                        widget.onClickThreeListMore(widget.position, userInfo);
                      },
                      onlineUserList: widget.onlineUserList,
                      isOwner: widget.isOwner,
                      isManager: widget.isManager,
                    ),
                    LivePopUserRankPage(
                      tabModel: tabs[1],
                      roomId: widget.roomId,
                    ),
                    LivePopUserRankPage(
                      tabModel: tabs[2],
                      roomId: widget.roomId,
                    )
                  ]))),
        ]));
  }

  ///更新禁言用户
  updateForbidUserInfo(int type,UserInfo userInfo) {
    _popUserOnLineKey.currentState?.updateForbidUserInfo(type,userInfo);
  }
}
