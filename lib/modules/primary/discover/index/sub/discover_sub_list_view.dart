import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/widgets/discover/discover_item.dart';
import 'package:youyu/services/voice_service.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/list/app_list_separated_view.dart';
import 'package:youyu/widgets/app/other/app_load_footer.dart';
import 'package:youyu/widgets/app/other/app_segmentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'discover_sub_list_logic.dart';
import 'package:youyu/widgets/page_life_state.dart';

class DiscoverSubListPage extends StatefulWidget {
  const DiscoverSubListPage({Key? key, required this.tabModel})
      : super(key: key);

  final TabModel tabModel;

  @override
  State<DiscoverSubListPage> createState() => _DiscoverSubListPageState();
}

class _DiscoverSubListPageState extends PageLifeState<DiscoverSubListPage>
    with AutomaticKeepAliveClientMixin {
  late DiscoverSubListLogic logic =
      Get.find<DiscoverSubListLogic>(tag: widget.tabModel.id.toString());

  @override
  void initState() {
    super.initState();
    Get.put<DiscoverSubListLogic>(DiscoverSubListLogic(),
        tag: widget.tabModel.id.toString());
    logic.tabModel = widget.tabModel;
    logic.subRefreshController = RefreshController();
    logic.loadData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppPage<DiscoverSubListLogic>(
      tag: widget.tabModel.id.toString(),
      backgroundColor: Colors.transparent,
      childBuilder: (s) {
        return _list();
      },
    );
  }

  _list() {
    return AppListSeparatedView(
      padding: EdgeInsets.only(top: 10.h, bottom: ScreenUtils.safeBottomHeight),
      controller: logic.subRefreshController,
      itemCount: logic.dataList.length,
      isOpenLoadMore: true,
      isOpenRefresh: true,
      separatorBuilder: (_, int index) {
        return AppSegmentation(
          height: 1.h,
          backgroundColor: const Color(0xFFE6E6E6),
        );
      },
      footer: AppLoadMoreFooter.getFooter(isEmptyData: logic.isNoData),
      isNoData: logic.isNoData,
      onRefresh: logic.pullRefresh,
      onLoad: logic.loadMore,
      itemBuilder: (_, int index) {
        var item = logic.dataList[index];
        return DisCoverItemWidget(
          model: item,
          index: index,
          ref: widget.tabModel.id == 1
              ? DisCoverItemRef.recommendList
              : DisCoverItemRef.focusList,
          onClickFocus: logic.onClickFocus,
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void onPagePause() {
    VoiceService().stopAudio();
  }

  @override
  void onPageResume() {}
}
