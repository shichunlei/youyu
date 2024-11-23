import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/submod/user/nobility/model/nobility_page_model.dart';
import 'package:youyu/modules/submod/user/nobility/widget/nobility_banner.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';
import 'nobility_logic.dart';
import 'pop/noblility_qa_pop.dart';

class NobilityPage extends StatelessWidget {
  NobilityPage({Key? key}) : super(key: key);

  final logic = Get.find<NobilityLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<NobilityLogic>(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppTopBar(
        backgroundColor: const Color(0xFF1C1C1E),
        title: "爵位",
        rightAction: AppLocalImage(
          path: AppResource().qa,
          width: 16.w,
        ),
        onTapRight: () {
          Get.dialog(const Center(
            child: NobilityQAPop(),
          ));
        },
      ),
      childBuilder: (s) {
        return AppColumn(
          children: [
            _tabBar(),
            SizedBox(
              height: 5.h,
            ),
            NobilityBanner(logic: logic),
            Expanded(child: _equity())
          ],
        );
      },
    );
  }

  _tabBar() {
    return SizedBox(
      height: 44.h,
      child: TabBar(
        tabAlignment: TabAlignment.start,
        dividerColor: Colors.transparent,
        automaticIndicatorColorAdjustment: false,
        tabs: logic.tabs.mapIndexed((index, e) {
          return Tab(
            text: e.customExtra?.nobility.name ?? "",
          );
        }).toList(),
        onTap: (index) {
          logic.tabTouchIndex(index);
        },
        indicatorColor: Colors.transparent,
        controller: logic.tabController,
        labelColor: const Color(0xFFFFDB86),
        labelStyle: TextStyle(fontSize: 18.sp),
        unselectedLabelColor: AppTheme.colorTextSecond,
        isScrollable: true,
        dragStartBehavior: DragStartBehavior.start,
      ),
    );
  }

  _equity() {
    return Obx(() => AppColumn(
          margin: EdgeInsets.only(top: 30.h),
          padding: EdgeInsets.only(top: 15.h),
          color: const Color(0xFF181617),
          children: [
            AppLocalImage(
              path: AppResource().nobilityEquityTitle,
              height: 16.h,
            ),
            Expanded(
                child: GridView.builder(
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.only(top: 21.h),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      //水平子Widget之间间距
                      crossAxisSpacing: 1,
                      //垂直子Widget之间间距
                      mainAxisSpacing: 1,
                      //一行的Widget数量
                      crossAxisCount: 3,
                      //子Widget宽高比例
                      childAspectRatio: 72 / 74,
                    ),
                    itemCount: logic.tabs[logic.currentIndex.value].customExtra
                        ?.equityList.length,
                    itemBuilder: (BuildContext context, int index) {
                      NobilityEquityModel? model = logic
                          .tabs[logic.currentIndex.value]
                          .customExtra
                          ?.equityList[index];
                      return AppColumn(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppLocalImage(
                            path: model?.image ?? "",
                            width: 50.w,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            model?.title ?? "",
                            style: AppTheme().textStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFFFFDB86)),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Text(
                            model?.title ?? "",
                            style: AppTheme().textStyle(
                                fontSize: 12.sp,
                                color: AppTheme.colorTextSecond),
                          )
                        ],
                      );
                    }))
          ],
        ));
  }
}
