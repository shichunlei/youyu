import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/models/localmodel/item_title_model.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/live/sub/setting/widget/live_setting_top_widget.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/icon/app_more_icon.dart';
import 'package:youyu/widgets/app/other/app_segmentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'live_setting_logic.dart';

class LiveSettingPage extends StatelessWidget {
  LiveSettingPage({Key? key}) : super(key: key);

  final logic = Get.find<LiveSettingLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<LiveSettingLogic>(
      appBar: const AppTopBar(
        title: "房间设置",
      ),
      childBuilder: (s) {
        return SingleChildScrollView(
          child: AppColumn(
            color: AppTheme.colorDarkBg,
            radius: 6.w,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 13.w),
            children: [
              //名称
              LiveSettingTopWidget(
                title: '房间名称',
                placeHolder: '请输入房间名称',
                controller: logic.nameController,
                onClick: () {
                  logic.showNameDialog();
                },
              ),
              //公告
              LiveSettingTopWidget(
                title: '房间公告',
                placeHolder: '请介绍下你的房间玩法与规则，听众了解...',
                controller: logic.noticeController,
                onClick: () {
                  logic.showNoticeDialog();
                },
              ),
              _list()
            ],
          ),
        );
      },
    );
  }

  _list() {
    return SizedBox(
      height: logic.list.length * 41.5.h + 5.h,
      child: ListView.separated(
          itemBuilder: (context, index) {
            ItemTitleModel model = logic.list[index];
            return AppRow(
              onTap: () {
                logic.onClickItem(model);
              },
              height: 42.h,
              children: [
                Text(
                  model.title,
                  style: AppTheme().textStyle(
                      fontSize: 14.sp, color: AppTheme.colorTextWhite),
                ),
                const Expanded(flex: 1, child: SizedBox.shrink()),
                Expanded(
                    flex: 2,
                    child: AppMoreIcon(
                      title: model.subTitle,
                      textColor: AppTheme.colorTextSecond,
                      height: 30.h,
                    ))
              ],
            );
          },
          separatorBuilder: (context, index) {
            return AppSegmentation(
              backgroundColor: AppTheme.colorLine,
              height: 0.5.h,
            );
          },
          itemCount: logic.list.length),
    );
  }
}
