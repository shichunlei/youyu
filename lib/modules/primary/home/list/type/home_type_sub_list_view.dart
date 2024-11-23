import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/models/room_list_item.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/list/app_grid_separated_view.dart';
import 'package:youyu/widgets/app/other/app_load_footer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'home_type_sub_list_logic.dart';
import 'package:youyu/widgets/page_life_state.dart';

import 'widget/home_type_sub_item.dart';

class HomeTypeSubListPage extends StatefulWidget {
  const HomeTypeSubListPage({Key? key, required this.tabModel})
      : super(key: key);
  final TabModel tabModel;

  @override
  State<HomeTypeSubListPage> createState() => _HomeTypeSubListPageState();
}

class _HomeTypeSubListPageState extends PageLifeState<HomeTypeSubListPage>
    with AutomaticKeepAliveClientMixin {
  late HomeTypeSubListLogic logic =
      Get.find<HomeTypeSubListLogic>(tag: "${widget.tabModel.id}");

  @override
  void initState() {
    super.initState();
    Get.put<HomeTypeSubListLogic>(HomeTypeSubListLogic(),
        tag: "${widget.tabModel.id}");
    logic.tabModel = widget.tabModel;
    logic.subRefreshController = RefreshController();
    logic.loadData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppPage<HomeTypeSubListLogic>(
      tag: "${widget.tabModel.id}",
      childBuilder: (s) {
        return AppGridSeparatedView(
          shrinkWrap: true,
          padding:
              EdgeInsets.only(top: 8.h, bottom: 10.h, left: 14.w, right: 14.w),
          controller: s.subRefreshController,
          itemCount: s.dataList.length,
          isOpenLoadMore: true,
          footer: AppLoadMoreFooter.getFooter(isEmptyData: s.isNoData),
          itemBuilder: (_, int index) {
            RoomListItem itemModel = s.dataList[index];
            return InkWell(
              onTap: () {
                LiveService().pushToLive(itemModel.id, itemModel.groupId);
              },
              child: HomeTypeSubItem(
                model: itemModel,
              ),
            );
          },
          //水平子Widget之间间距
          crossAxisSpacing: 8.w,
          //垂直子Widget之间间距
          mainAxisSpacing: 9.h,
          //一行的Widget数量
          crossAxisCount: 2,
          //子Widget宽高比例
          childAspectRatio: 170 / 195,
          isNoData: s.isNoData,
          onRefresh: s.pullRefresh,
          onLoad: s.loadMore,
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void onPagePause() {}

  @override
  void onPageResume() {
    logic.pullRefresh();
  }
}
