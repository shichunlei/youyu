import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/widgets/search/search_input_widget.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/modules/primary/discover/userlist/sub/item/discover_pop_user_item.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';
import 'package:youyu/widgets/app/list/app_list_separated_view.dart';
import 'package:youyu/widgets/app/other/app_load_footer.dart';
import 'package:youyu/widgets/app/other/app_segmentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'discover_pop_user_logic.dart';

class DiscoverPopUserSubPage extends StatefulWidget {
  const DiscoverPopUserSubPage(
      {Key? key, required this.tabModel, required this.selUserIds, required this.selUserNames})
      : super(key: key);

  final TabModel tabModel;
  final List<String> selUserIds;
  final List<String> selUserNames;

  @override
  State<DiscoverPopUserSubPage> createState() => DiscoverPopUserSubPageState();
}

class DiscoverPopUserSubPageState extends State<DiscoverPopUserSubPage>
    with AutomaticKeepAliveClientMixin {
  late DiscoverPopUserSubLogic logic =
      Get.find<DiscoverPopUserSubLogic>(tag: widget.tabModel.id.toString());

  @override
  void initState() {
    super.initState();
    Get.put<DiscoverPopUserSubLogic>(DiscoverPopUserSubLogic(),
        tag: widget.tabModel.id.toString());
    logic.tabModel = widget.tabModel;
    logic.selUserIds = widget.selUserIds;
    logic.selUserNames = widget.selUserNames;
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
          height: 5.h,
        ),
        Expanded(
            child: AppPage<DiscoverPopUserSubLogic>(
          backgroundColor: AppTheme.colorDarkBg,
          tag: widget.tabModel.id.toString(),
          childBuilder: (s) {
            return AppListSeparatedView(
              padding: EdgeInsets.only(bottom: ScreenUtils.safeBottomHeight),
              controller: s.subRefreshController,
              itemCount: s.dataList.length,
              isOpenLoadMore: true,
              isOpenRefresh: true,
              separatorBuilder: (_, int index) {
                return AppSegmentation(
                  height: 1.h,
                  backgroundColor: AppTheme.colorLine,
                );
              },
              itemBuilder: (_, int index) {
                UserInfo userInfo = s.dataList[index];
                return AppColumn(
                  children: [
                    DiscoverPopUserItem(
                      index: index,
                      model: userInfo,
                      isSel: logic.selUserIds.contains(userInfo.id.toString()),
                      onClickItem: () {
                        logic.onClickItem(userInfo);
                      },
                    ),
                    if (index == s.dataList.length - 1)
                      SizedBox(
                        height: 20.h,
                      )
                  ],
                );
              },
              onRefresh: logic.pullRefresh,
              onLoad: logic.loadMore,
              footer: AppLoadMoreFooter.getFooter(isEmptyData: logic.isNoData),
              isNoData: logic.isNoData,
            );
          },
        )),
      ],
    );
  }

  _searchWidget() {
    return Container(
      margin: EdgeInsets.only(left: 20.w, right: 20.w),
      child: Row(
        children: [
          Expanded(
              child: SearchInputWidget(
                  height: 34.h,
                  backgroundColor: const Color(0xFF000000),
                  onSubmitted: logic.onSubmitted,
                  placeHolder: '输入用户ID或昵称D',
                  controller: logic.controller)),
          SizedBox(
            width: 10.w,
          ),
          AppColorButton(
            title: "搜索",
            fontSize: 14.sp,
            width: 70.w,
            height: 30.h,
            onClick: () {
              logic.onSubmitted(logic.controller.text);
            },
            titleColor: const Color(0xFF000000),
            bgGradient: AppTheme().btnGradient,
          )
        ],
      ),
    );
  }

  updateUI() {
    logic.setSuccessType();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    Get.delete<DiscoverPopUserSubLogic>(tag: widget.tabModel.id.toString());
    super.dispose();
  }
}
