import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/search/search_top_bar.dart';
import 'package:youyu/widgets/tabbar/curve_tab_bar.dart';
import 'package:youyu/modules/submod/search/list/room/search_room_list_view.dart';
import 'package:youyu/modules/submod/search/list/user/search_user_list_view.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'search_sub_logic.dart';

class SearchSubPage extends StatelessWidget {
  SearchSubPage({Key? key}) : super(key: key);

  final logic = Get.find<SearchSubLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<SearchSubLogic>(
      resizeToAvoidBottomInset: false,
      appBar: SearchTopBar(
        controller: logic.searchController,
        onSubmitted: (value) {
          logic.search(value);
        },
        extraHeight: 50.h,
        extraWidget: _tabBar(),
      ),
      childBuilder: (s) {
        return TabBarView(
            controller: logic.tabController,
            children: logic.tabs.map((e) {
              switch (e.id) {
                case 0:
                  //相关房间
                  return SearchRoomListPage(
                    list: logic.roomList,
                  );
                case 1:
                  //相关用户
                  return SearchUserListPage(
                    list: logic.userList,
                  );
                default:
                  return Container();
              }
            }).toList());
      },
    );
  }

  ///tabBar
  _tabBar() {
    return CurveTabBar(
      tabs: logic.tabs,
      fontSize: 14.sp,
      tabController: logic.tabController,
      labelPadding: EdgeInsets.only(left: 28.w, right: 28.w),
      indicatorPadding: EdgeInsets.only(top: 30.h, left: 2.w, right: 2.w),
      isScrollable: true,
    );
  }
}
