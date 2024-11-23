import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/app/app_default.dart';

import 'package:youyu/widgets/search/search_input_widget.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/router/router.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/list/app_list_separated_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'conference_index_logic.dart';
import 'widget/conference_item_widget.dart';

class ConferenceIndexPage extends StatelessWidget {
  ConferenceIndexPage({Key? key}) : super(key: key);

  final logic = Get.find<ConferenceIndexLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<ConferenceIndexLogic>(
      resizeToAvoidBottomInset: false,
      appBar: const AppTopBar(
        title: "公会",
      ),
      childBuilder: (s) {
        return AppColumn(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          children: [
            SearchInputWidget(
              height: 38.h,
              placeHolder: '搜索公会名称或ID',
              onSubmitted: (text) {
                logic.onClickSearch(text);
              },
            ),
            SizedBox(
              height: 14.h,
            ),
            Expanded(
                child: AppContainer(
              topLeftRadius: 6.w,
              topRightRadius: 6.w,
              color: AppTheme.colorDarkBg,
              child: AppListSeparatedView(
                padding: EdgeInsets.only(
                    top: 10.h, bottom: ScreenUtils.safeBottomHeight + 10.h),
                controller: logic.refreshController,
                itemCount: logic.dataList.length,
                isOpenLoadMore: true,
                defaultConfig: AppDefaultConfig(
                    image: AppResource().conferenceEmpty, title: "暂无数据"),
                isOpenRefresh: true,
                onRefresh: logic.pullRefresh,
                onLoad: logic.loadMore,
                isNoData: logic.isNoData,
                separatorBuilder: (_, int index) {
                  return SizedBox(
                    height: 12.h,
                  );
                },
                itemBuilder: (_, int index) {
                  var item = logic.dataList[index];
                  return ConferenceItemWidget(
                    item: item,
                    onClickItem: () {
                      Get.toNamed(
                          AppRouter()
                              .otherPages
                              .conferenceDetailRoute
                              .name,
                          arguments: {
                            'state':0,
                            'item':item
                          });
                    },
                  );
                },
              ),
            ))
          ],
        );
      },
    );
  }
}
