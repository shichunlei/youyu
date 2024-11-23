import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/modules/setting/black/widget/setting_black_item.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/list/app_list_separated_view.dart';
import 'package:youyu/widgets/app/other/app_segmentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'setting_black_logic.dart';

class SettingBlackPage extends StatelessWidget {
  SettingBlackPage({Key? key}) : super(key: key);

  final logic = Get.find<SettingBlackLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<SettingBlackLogic>(
      appBar: const AppTopBar(
        title: "黑名单",
      ),
      childBuilder: (s) {
        return AppContainer(
          margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 15.h),
          topRightRadius: 6.w,
          topLeftRadius: 6.w,
          color: AppTheme.colorDarkBg,
          child: AppListSeparatedView(
            padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
            controller: s.refreshController,
            itemCount: s.dataList.length,
            isOpenLoadMore: true,
            isOpenRefresh: true,
            isNoData: logic.isNoData,
            separatorBuilder: (_, int index) {
              return AppSegmentation(
                backgroundColor: AppTheme.colorLine,
                margin: EdgeInsets.symmetric(horizontal: 15.w),
                height: 0.5.h,
              );
            },
            itemBuilder: (_, int index) {
              UserInfo model = s.dataList[index];
              return SettingBlackItem(model: model, onClickRemove: () {
                logic.onClickRemove(model);
              },);
            },
            onRefresh: () {
              s.pullRefresh();
            },
          ),
        );
      },
    );
  }
}
