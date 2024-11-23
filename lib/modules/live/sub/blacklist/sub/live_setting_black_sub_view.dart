import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/modules/live/common/notification/live_setting_notify.dart';
import 'package:youyu/modules/live/sub/blacklist/widget/live_setting_black_item.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/list/app_list_separated_view.dart';
import 'package:youyu/widgets/app/other/app_segmentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'live_setting_black_sub_logic.dart';

class LiveSettingBlackSubPage extends StatefulWidget {
  const LiveSettingBlackSubPage(
      {Key? key,
      required this.tabModel,
      required this.roomId,
      required this.settingNotify})
      : super(key: key);
  final TabModel tabModel;
  final int roomId;
  final LiveSettingNotify settingNotify;

  @override
  State<LiveSettingBlackSubPage> createState() =>
      _LiveSettingBlackSubPageState();
}

class _LiveSettingBlackSubPageState extends State<LiveSettingBlackSubPage>
    with AutomaticKeepAliveClientMixin {
  late LiveSettingBlackSubLogic logic =
      Get.find<LiveSettingBlackSubLogic>(tag: "${widget.tabModel.id}");

  @override
  void initState() {
    super.initState();
    Get.put<LiveSettingBlackSubLogic>(LiveSettingBlackSubLogic(),
        tag: "${widget.tabModel.id}");
    logic.roomId = widget.roomId;
    logic.settingNotify = widget.settingNotify;
    logic.subRefreshController = RefreshController();
    logic.tabModel = widget.tabModel;
    logic.loadData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppPage<LiveSettingBlackSubLogic>(
      tag: widget.tabModel.id.toString(),
      childBuilder: (s) {
        return AppListSeparatedView(
          padding: EdgeInsets.only(
              top: 10.h, bottom: ScreenUtils.safeBottomHeight + 8.h),
          controller: s.subRefreshController,
          itemCount: s.dataList.length,
          isOpenLoadMore: true,
          isOpenRefresh: true,
          separatorBuilder: (_, int index) {
            return AppSegmentation(
              height: 14.h,
            );
          },
          itemBuilder: (_, int index) {
            return LiveSettingBlackItem(
              model: s.dataList[index],
              type: widget.tabModel.id,
              onClickRemove: () {
                logic.onRemove(s.dataList[index]);
              },
            );
          },
          isNoData: logic.isNoData,
          onRefresh: () {
            s.pullRefresh();
          },
          onLoad: () {
            s.loadMore();
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
