import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/live/sub/manager/widget/live_setting_manager_item.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/list/app_list_separated_view.dart';
import 'package:youyu/widgets/app/other/app_segmentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'live_setting_manager_logic.dart';

class LiveSettingManagerPage extends StatelessWidget {
  LiveSettingManagerPage({Key? key}) : super(key: key);

  final logic = Get.find<LiveSettingManagerLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<LiveSettingManagerLogic>(
      appBar: AppTopBar(
        title: "管理列表",
        rightAction: AppContainer(
          onTap: () {
            logic.pushToSearch();
          },
          width: 60.w,
          child: Center(
            child: Text(
              "添加",
              style: AppTheme().textStyle(
                  fontSize: 13.sp, color: AppTheme.colorTextSecond),
            ),
          ),
        ),
      ),
      childBuilder: (s) {
        return AppListSeparatedView(
          padding: EdgeInsets.only(
              top: 10.h, bottom: ScreenUtils.safeBottomHeight + 8.h),
          controller: s.refreshController,
          itemCount: s.dataList.length,
          isOpenLoadMore: false,
          isOpenRefresh: false,
          isNoData: logic.isNoData,
          separatorBuilder: (_, int index) {
            return AppSegmentation(
              height: 14.h,
            );
          },
          itemBuilder: (_, int index) {
            return LiveSettingManagerItem(
              model: s.dataList[index],
              onCancelManager: logic.onCancelManager,
              onSetManager: logic.onSetManager,
            );
          },
        );
      },
    );
  }
}
