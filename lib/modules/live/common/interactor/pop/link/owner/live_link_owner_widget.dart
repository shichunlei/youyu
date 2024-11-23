import 'package:get/get.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/modules/live/common/interactor/pop/link/owner/sub/apply/live_link_owner_apply_view.dart';
import 'package:youyu/modules/live/common/interactor/pop/link/owner/sub/invite/live_link_owner_invite_view.dart';
import 'package:youyu/modules/live/common/interactor/pop/link/owner/sub/set/live_link_owner_set_view.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/live/common/interactor/pop/userlist/widget/live_pop_user_tab_bar.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_round_container.dart';
import 'package:flutter/material.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';

///用户列表
class LiveLinkOwnerList extends StatefulWidget {
  const LiveLinkOwnerList({
    super.key,
    required this.roomId,
    required this.onlineUserList,
  });

  final int roomId;
  final List<UserInfo> onlineUserList;

  @override
  State<LiveLinkOwnerList> createState() => LiveLinkOwnerListState();
}

class LiveLinkOwnerListState extends State<LiveLinkOwnerList>
    with SingleTickerProviderStateMixin {
  ///tab
  late TabController tabController;
  List<TabModel> tabs = [];

  @override
  void initState() {
    super.initState();
    tabs.addAll([
      TabModel(id: 0, name: "申请消息"),
      TabModel(id: 1, name: "邀请连麦"),
      TabModel(id: 2, name: "连麦设置"),
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
        height: 390.h,
        child: Column(children: [
          AppRow(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            width: double.infinity,
            height: 44.h,
            children: [
              SizedBox(
                width: 50.w,
              ),
              Text(
                "互动连麦",
                style:
                    AppTheme().textStyle(fontSize: 18.sp, color: Colors.white),
              ),
              AppContainer(
                onTap: () {
                  Get.back();
                },
                width: 50.w,
                child: Center(
                  child: AppLocalImage(
                    path: AppResource().close,
                    width: 12.w,
                  ),
                ),
              )
            ],
          ),
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
                    LiveLinkOwnerApplyPage(
                      tabModel: tabs[0],
                      roomId: widget.roomId,
                    ),
                    LiveLinkOwnerInvitePage(
                      tabModel: tabs[1],
                      roomId: widget.roomId,
                      onlineUserList: widget.onlineUserList,
                    ),
                    LiveLinkOwnerSetPage(
                      tabModel: tabs[2],
                      roomId: widget.roomId,
                    )
                  ]))),
        ]));
  }
}
