import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/widgets/navbar/transparent_nav_bar.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/user_level.dart';
import 'package:youyu/modules/submod/user/level/widget/level_fist_item.dart';
import 'package:youyu/modules/submod/user/level/widget/level_item.dart';
import 'package:youyu/modules/submod/user/level/widget/level_top_widget.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/list/app_list_separated_view.dart';
import 'package:youyu/widgets/app/other/app_segmentation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'level_logic.dart';

class LevelPage extends StatelessWidget {
  LevelPage({Key? key}) : super(key: key);

  final logic = Get.find<LevelLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<LevelLogic>(
      childBuilder: (s) {
        return AppStack(
          children: [
            AppContainer(
              width: double.infinity,
              height: 159.h + 17.h + ScreenUtils.statusBarHeight,
              gradientStartColor: const Color(0xFF9FD96B),
              gradientEndColor: const Color(0xFF54DA95),
              gradientBegin: Alignment.topCenter,
              gradientEnd: Alignment.bottomCenter,
            ),
            AppColumn(
              margin: EdgeInsets.zero,
              color: Colors.transparent,
              children: [
                TransparentNavBar(
                  title: "等级说明",
                  titleColor: const Color(0xFF000000),
                  leftImage: AppResource().blackBack,
                  onClickLeft: () {
                    Get.back();
                  },
                ),
                LevelTopWidget(
                  height: 109.h,
                  curLevelModel: logic.curLevelModel,
                ),
                Expanded(child: _content())
              ],
            ),
          ],
        );
      },
    );
  }

  _content() {
    return SingleChildScrollView(
      child: AppColumn(
        color: Colors.transparent,
        children: [
          AppColumn(
            mainAxisSize: MainAxisSize.min,
            radius: 6.w,
            padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 15.w),
            margin: EdgeInsets.symmetric(horizontal: 14.w),
            color: AppTheme.colorDarkBg,
            children: [
              Text(
                '每消耗1豆，可获得1经验值，达到级别所需的经验值即可自动升级。',
                maxLines: 3,
                style: AppTheme().textStyle(
                    fontSize: 12.sp, color: AppTheme.colorTextWhite),
              )
            ],
          ),
          SizedBox(
            height: ScreenUtils.screenHeight -
                109.h -
                ScreenUtils.navbarHeight -
                ScreenUtils.statusBarHeight -
                66.h,
            child: AppListSeparatedView(
              padding: EdgeInsets.only(
                  top: 21.h, bottom: ScreenUtils.safeBottomHeight),
              controller: logic.refreshController,
              itemCount: UserController.to.levelControl.levelList.length + 1,
              isOpenLoadMore: false,
              isOpenRefresh: false,
              separatorBuilder: (_, int index) {
                return AppSegmentation(
                  margin: EdgeInsets.symmetric(horizontal: 15.w),
                  height: 1.h,
                  backgroundColor: AppTheme.colorLine,
                );
              },
              itemBuilder: (_, int index) {
                if (index == 0) {
                  return const LevelFirstItem();
                } else {
                  UserLevel level =
                      UserController.to.levelControl.levelList[index - 1];
                  return LevelItem(
                    model: level,
                    index: index - 1,
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
