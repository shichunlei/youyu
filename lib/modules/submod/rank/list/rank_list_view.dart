import 'package:youyu/modules/submod/rank/list/model/cp_rank_list_model.dart';
import 'package:youyu/modules/submod/rank/list/widget/cp_rank_list_item_widget.dart';
import 'package:youyu/modules/submod/rank/list/widget/cp_rank_list_top_widget.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/modules/submod/rank/list/model/rank_list_top_model.dart';
import 'package:youyu/modules/submod/rank/list/widget/rank_list_item_widget.dart';
import 'package:youyu/modules/submod/rank/list/widget/rank_list_top_widget.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:youyu/widgets/app/list/app_list_separated_view.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/other/app_segmentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'rank_list_logic.dart';

class RankListPage extends StatefulWidget {
  const RankListPage(
      {Key? key, this.roomId, required this.mainTab, required this.subTab})
      : super(key: key);

  final String? roomId;
  final TabModel mainTab;
  final TabModel subTab;

  @override
  State<RankListPage> createState() => _RankListPageState();
}

class _RankListPageState extends State<RankListPage>
    with AutomaticKeepAliveClientMixin {
  late RankListLogic logic =
      Get.find<RankListLogic>(tag: "${widget.mainTab.id}-${widget.subTab.id}");

  @override
  void initState() {
    super.initState();
    Get.put<RankListLogic>(RankListLogic(),
        tag: "${widget.mainTab.id}-${widget.subTab.id}");
    logic.subRefreshController = RefreshController();
    logic.roomId = widget.roomId;
    logic.mainTab = widget.mainTab;
    logic.subTab = widget.subTab;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppPage<RankListLogic>(
      tag: "${widget.mainTab.id}-${widget.subTab.id}",
      backgroundColor: Colors.transparent,
      childBuilder: (s) {
        return AppListSeparatedView(
          padding: EdgeInsets.only(
              top: 5.h, bottom: ScreenUtils.safeBottomHeight + 10.h),
          controller: s.subRefreshController,
          itemCount: s.allData.length,
          isOpenLoadMore: false,
          isOpenRefresh: false,
          separatorBuilder: (_, int index) {
            return AppSegmentation(
              height: 10.h,
              backgroundColor: Colors.transparent,
            );
          },
          itemBuilder: (_, int index) {
            var item = s.allData[index];
            if (item is RankListTopModel) {
              return RankListTopWidget(
                list: item.list,
                onClickUserItem: (UserInfo model) {
                  UserController.to
                      .pushToUserDetail(model.id ?? 0, UserDetailRef.other);
                },
                onClickLiveItem: (UserInfo model) {
                  LiveService().pushToLive(
                      model.thisRoomInfo?.id, model.thisRoomInfo?.groupId);
                },
                mainTab: widget.mainTab,
              );
            } else if (item is UserInfo) {
              return RankListItemWidget(
                model: item,
                index: index + 3,
                onClickUserItem: () {
                  UserController.to
                      .pushToUserDetail(item.id, UserDetailRef.other);
                },
                onClickLiveItem: () {
                  LiveService().pushToLive(
                      item.thisRoomInfo?.id, item.thisRoomInfo?.groupId);
                },
                mainTab: widget.mainTab,
                subTab: widget.subTab,
              );
            } else if (item is CpRankListTopModel) {
              return CpRankListTopWidget(
                list: item.list,
                onClickUserItem: (UserInfo model) {
                  UserController.to
                      .pushToUserDetail(model.id ?? 0, UserDetailRef.other);
                },
                onClickLiveItem: (UserInfo model) {
                  LiveService().pushToLive(
                      model.thisRoomInfo?.id, model.thisRoomInfo?.groupId);
                },
                mainTab: widget.mainTab,
              );
            } else if (item is CpRankModel) {
              return CpRankListItemWidget(
                model: item,
                index: index + 3,
                onClickUserItem: () {
                  // UserController.to
                  //     .pushToUserDetail(item.id, UserDetailRef.other);
                },
                onClickLiveItem: () {
                  // LiveService().pushToLive(
                  //     item.thisRoomInfo?.id, item.thisRoomInfo?.groupId);
                },
                mainTab: widget.mainTab,
              );
            }
            return Container();
          },
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
