import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/search/search_input_widget.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/primary/mine/follow_live/widget/follow_live_item.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/list/app_list_separated_view.dart';
import 'package:youyu/widgets/app/other/app_segmentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'follow_live_logic.dart';

class FollowLivePage extends StatelessWidget {
  FollowLivePage({Key? key}) : super(key: key);

  final logic = Get.find<FollowLiveLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<FollowLiveLogic>(
      resizeToAvoidBottomInset: false,
      appBar: const AppTopBar(
        title: "关注直播间",
      ),
      childBuilder: (s) {
        return AppColumn(
          padding: EdgeInsets.only(
              left: 15.w, right: 15.w, bottom: ScreenUtils.safeBottomHeight),
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SearchInputWidget(
              height: 38.h,
              controller: logic.searchController,
              placeHolder: '搜索房间名或ID',
              enabled: true,
              onSubmitted: (text) {
                logic.onClickSearch();
              },
            ),
            SizedBox(
              height: 14.h,
            ),
            Expanded(
              child: AppContainer(
                radius: 10.w,
                color: AppTheme.colorDarkBg,
                child: AppListSeparatedView(
                  padding: EdgeInsets.only(
                      top: 10.h, bottom: ScreenUtils.safeBottomHeight + 10.h),
                  controller: logic.refreshController,
                  itemCount: logic.allData.length,
                  isOpenLoadMore: false,
                  isOpenRefresh: false,
                  isNoData: logic.isNoData,
                  separatorBuilder: (_, int index) {
                    return AppSegmentation(
                      height: 12.h,
                      backgroundColor: Colors.transparent,
                    );
                  },
                  itemBuilder: (_, int index) {
                    var item = logic.allData[index];
                    return FollowLiveItem(
                      model: item,
                      onClickCancelFocus: () {
                        logic.onClickCancelFocus(item);
                      },
                      onClickLive: () {
                        logic.onClickLive(item);
                      },
                    );
                  },
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
