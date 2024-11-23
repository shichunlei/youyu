import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/tabbar/curve_tab_bar.dart';
import 'package:youyu/modules/wallet/backpack/index/back_pack_order_logic.dart';
import 'package:youyu/modules/wallet/backpack/index/list/back_pack_order_list_view.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackPackOrderPage extends StatelessWidget {
  BackPackOrderPage({Key? key}) : super(key: key);

  final logic = Get.find<BackPackOrderLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<BackPackOrderLogic>(
      appBar: const AppTopBar(
        title: "背包礼物账单",
      ),
      childBuilder: (s) {
        return AppColumn(
          padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 15.w),
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 160.w,
              height: 58.h,
              child: CurveTabBar(
                tabs: logic.tabs,
                fontSize: 14.sp,
                tabController: logic.tabController,
                labelPadding: EdgeInsets.only(left: 8.w, right: 8.w),
                indicatorPadding:
                    EdgeInsets.only(top: 30.h, left: 2.w, right: 2.w),
                isScrollable: false,
              ),
            ),
            Expanded(
              child: TabBarView(
                  controller: logic.tabController,
                  children: logic.tabs.map((e) {
                    if (e.id == 1) {
                      return const BackPackOrderListPage(
                        isIn: false,
                      );
                    } else {
                      return const BackPackOrderListPage(
                        isIn: true,
                      );
                    }
                  }).toList()),
            )
          ],
        );
      },
    );
  }
}
