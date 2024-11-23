import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/discover/discover_item.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/discover_item.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/list/app_list_separated_view.dart';
import 'package:youyu/widgets/app/other/app_load_footer.dart';
import 'package:youyu/widgets/app/other/app_segmentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'user_dynamic_logic.dart';

class UserDynamicPage extends StatefulWidget {
  const UserDynamicPage({Key? key, required this.userId, required this.ref})
      : super(key: key);

  //系统用户id
  final int userId;
  final UserDetailRef ref;

  @override
  State<UserDynamicPage> createState() => _UserDynamicPageState();
}

class _UserDynamicPageState extends State<UserDynamicPage>
    with AutomaticKeepAliveClientMixin {
  final logic = Get.put(UserDynamicLogic());

  @override
  void initState() {
    super.initState();
    logic.refreshController = RefreshController();
    logic.userId = widget.userId;
    logic.ref = widget.ref;
    Future.delayed(const Duration(milliseconds: 200), () {
      logic.loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppPage<UserDynamicLogic>(
      isUseScaffold: false,
      backgroundColor: Colors.transparent,
      childBuilder: (s) {
        return AppListSeparatedView(
          padding: EdgeInsets.only(
              top: 10.h, bottom: ScreenUtils.safeBottomHeight + 70.h),
          controller: logic.refreshController,
          itemCount: logic.dataList.length,
          isOpenLoadMore: true,
          isOpenRefresh: false,
          footer: AppLoadMoreFooter.getFooter(isEmptyData: logic.isNoData),
          isNoData: logic.isNoData,
          onLoad: logic.loadMore,
          separatorBuilder: (_, int index) {
            return AppSegmentation(
              height: 9.h,
            );
          },
          itemBuilder: (_, int index) {
            var item = logic.dataList[index];
            return DisCoverItemWidget(
              model: item,
              index: index,
              onClickLive: logic.ref == UserDetailRef.live
                  ? (DiscoverItem? model) {
                      //..
                    }
                  : null,
              onClickUser: logic.ref == UserDetailRef.live
                  ? (DiscoverItem? model) {
                      //..
                    }
                  : null,
              ref: DisCoverItemRef.userList,
              onClickFocus: logic.onClickFocus,
            );
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
