import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/tabbar/curve_tab_bar.dart';
import 'package:youyu/modules/primary/mine/friend/list/friend_list_view.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'friend_logic.dart';

class FriendPage extends StatelessWidget {
  FriendPage({Key? key}) : super(key: key);

  final logic = Get.find<FriendLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<FriendLogic>(
      resizeToAvoidBottomInset: false,
      appBar: const AppTopBar(
        title: "好友",
      ),
      childBuilder: (s) {
        return AppColumn(
          padding: EdgeInsets.only(
              left: 15.w, right: 15.w, bottom: ScreenUtils.safeBottomHeight),
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
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
                    if (e.id == 0) {
                      return FriendListPage(
                        model: e,
                      );
                    } else {
                      return FriendListPage(
                        model: e,
                      );
                    }
                  }).toList()),
            )
          ],
        );
      },
    );
  }
}
