import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/primary/discover/notification/sub/widget/discover_notification_item.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/list/app_list_separated_view.dart';
import 'package:youyu/widgets/app/other/app_load_footer.dart';
import 'package:youyu/widgets/app/other/app_segmentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'discover_notification_sub_logic.dart';

class DiscoverNotificationSubPage extends StatefulWidget {
  const DiscoverNotificationSubPage({Key? key, required this.tabModel})
      : super(key: key);
  final TabModel tabModel;

  @override
  State<DiscoverNotificationSubPage> createState() =>
      _DiscoverNotificationSubPageState();
}

class _DiscoverNotificationSubPageState
    extends State<DiscoverNotificationSubPage> {
  late DiscoverNotificationSubLogic logic =
      Get.find<DiscoverNotificationSubLogic>(
          tag: widget.tabModel.id.toString());

  @override
  void initState() {
    super.initState();
    Get.put<DiscoverNotificationSubLogic>(DiscoverNotificationSubLogic(),
        tag: widget.tabModel.id.toString());
    logic.tabModel = widget.tabModel;
    logic.subRefreshController = RefreshController();
    logic.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return AppPage<DiscoverNotificationSubLogic>(
      tag: widget.tabModel.id.toString(),
      childBuilder: (s) {
        return AppContainer(
          radius: 6.w,
          color: AppTheme.colorDarkBg,
          child: _list(),
        );
      },
    );
  }

  _list() {
    return AppListSeparatedView(
      padding: EdgeInsets.only(bottom: ScreenUtils.safeBottomHeight),
      controller: logic.subRefreshController,
      itemCount: logic.dataList.length,
      isOpenLoadMore: true,
      isOpenRefresh: true,
      footer: AppLoadMoreFooter.getFooter(isEmptyData: logic.isNoData),
      isNoData: logic.isNoData,
      onRefresh: logic.pullRefresh,
      onLoad: logic.loadMore,
      separatorBuilder: (_, int index) {
        return AppSegmentation(
          height: 1.h,
          backgroundColor: AppTheme.colorLine,
        );
      },
      itemBuilder: (_, int index) {
        var item = logic.dataList[index];
        return DiscoverNotificationItem(
          model: item,
          tabId: logic.tabModel.id,
        );
      },
    );
  }
}
