import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/widgets/search/search_input_widget.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/conversation_controller.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/modules/primary/mine/friend/list/widget/friend_list_item.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/list/app_list_separated_view.dart';
import 'package:youyu/widgets/app/other/app_segmentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'friend_list_logic.dart';

class FriendListPage extends StatefulWidget {
  const FriendListPage({Key? key, required this.model}) : super(key: key);
  final TabModel model;

  @override
  State<FriendListPage> createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage>
    with AutomaticKeepAliveClientMixin {
  late FriendListLogic logic =
      Get.find<FriendListLogic>(tag: widget.model.id.toString());

  @override
  void initState() {
    super.initState();
    Get.put<FriendListLogic>(FriendListLogic(),
        tag: widget.model.id.toString());
    logic.tabModel = widget.model;
    logic.subRefreshController = RefreshController();
    logic.loadData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        _searchWidget(),
        SizedBox(
          height: 14.h,
        ),
        Expanded(
            child: AppPage<FriendListLogic>(
          tag: widget.model.id.toString(),
          resizeToAvoidBottomInset: false,
          isUseScaffold: false,
          childBuilder: (s) {
            return AppContainer(
              radius: 10.w,
              color: AppTheme.colorDarkBg,
              child: AppListSeparatedView(
                padding: EdgeInsets.only(
                    top: 10.h, bottom: ScreenUtils.safeBottomHeight + 10.h),
                controller: logic.subRefreshController,
                itemCount: logic.dataList.length,
                isOpenLoadMore: true,
                isOpenRefresh: true,
                onRefresh: logic.pullRefresh,
                onLoad: logic.loadMore,
                isNoData: logic.isNoData,
                separatorBuilder: (_, int index) {
                  return AppSegmentation(
                    height: 12.h,
                    backgroundColor: Colors.transparent,
                  );
                },
                itemBuilder: (_, int index) {
                  var item = logic.dataList[index];
                  return FriendListItem(
                    userInfo: item,
                    onClickItem: () {
                      logic.onClickUser(item);
                    },
                    onClickLive: (UserInfo? userInfo) {
                      ConversationController.to.pushToLive(userInfo);
                    },
                  );
                },
              ),
            );
          },
        ))
      ],
    );
  }

  _searchWidget() {
    return SearchInputWidget(
      height: 38.h,
      controller: logic.controller,
      placeHolder: '搜索用户昵称、ID或备注',
      enabled: true,
      onSubmitted: logic.onSubmitted,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
