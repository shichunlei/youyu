import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/search/search_top_bar.dart';
import 'package:youyu/modules/live/sub/manager/widget/live_setting_manager_item.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/list/app_list_separated_view.dart';
import 'package:youyu/widgets/app/other/app_segmentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'live_setting_manager_search_logic.dart';

class LiveSettingManagerSearchPage extends StatelessWidget {
  LiveSettingManagerSearchPage({Key? key}) : super(key: key);

  final logic = Get.find<LiveSettingManagerSearchLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<LiveSettingManagerSearchLogic>(
      resizeToAvoidBottomInset: false,
      appBar: SearchTopBar(
        controller: logic.searchController,
        placeHolder: "搜索昵称或ID",
        onSubmitted: (value) {
          logic.search(value);
        },
      ),
      childBuilder: (s) {
        return AppListSeparatedView(
          padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
          controller: s.refreshController,
          itemCount: s.list.length,
          isOpenRefresh: false,
          isOpenLoadMore: false,
          isNoData: logic.isNoData,
          separatorBuilder: (_, int index) {
            return AppSegmentation(
              height: 14.h,
            );
          },
          itemBuilder: (_, int index) {
            return LiveSettingManagerItem(
              model: s.list[index],
              onCancelManager: logic.onCancelManager,
              onSetManager: logic.onSetManager,
            );
          },
        );
      },
    );
  }
}
