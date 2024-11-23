import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/list/app_list_separated_view.dart';
import 'package:youyu/widgets/app/other/app_segmentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'item/live_pop_user_rank_sub_item.dart';
import 'live_pop_user_rank_sub_logic.dart';

class LivePopUserRankSubPage extends StatefulWidget {
  const LivePopUserRankSubPage({Key? key, required this.roomId, this.mainTab, this.subTab})
      : super(key: key);

  ///参数
  final int roomId;
  final TabModel? mainTab;
  final TabModel? subTab;

  @override
  State<LivePopUserRankSubPage> createState() => _LivePopUserRankSubPageState();
}

class _LivePopUserRankSubPageState extends State<LivePopUserRankSubPage>
    with AutomaticKeepAliveClientMixin {
  late LivePopUserRankSubLogic logic = Get.find<LivePopUserRankSubLogic>(
      tag: "${widget.mainTab?.id}-${widget.subTab?.id}");

  @override
  void initState() {
    super.initState();
    Get.put<LivePopUserRankSubLogic>(LivePopUserRankSubLogic(),
        tag: "${widget.mainTab?.id}-${widget.subTab?.id}");
    logic.subRefreshController = RefreshController();
    logic.roomId = widget.roomId;
    logic.mainTab = widget.mainTab;
    logic.subTab = widget.subTab;
    logic.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppPage<LivePopUserRankSubLogic>(
      tag: "${widget.mainTab?.id}-${widget.subTab?.id}",
      backgroundColor: Colors.transparent,
      childBuilder: (s) {
        return AppListSeparatedView(
          padding:
              EdgeInsets.only(top: 5.h, bottom: ScreenUtils.safeBottomHeight),
          controller: s.subRefreshController,
          itemCount: s.allData.length,
          isOpenLoadMore: false,
          isOpenRefresh: false,
          isNoData: logic.isNoData,
          separatorBuilder: (_, int index) {
            return AppSegmentation(
              height: 1.h,
              backgroundColor: AppTheme.colorLine,
            );
          },
          itemBuilder: (_, int index) {
            return LivePopUserRankSubItem(
              model: s.allData[index],
              index: index, mainTab: widget.mainTab,
            );
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
