import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/tabbar/curve_tab_bar.dart';
import 'package:youyu/modules/wallet/exchange/index/withdraw/withdraw_view.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'exchange/exchange_view.dart';
import 'exchange_index_logic.dart';

class ExchangeIndexPage extends StatelessWidget {
  ExchangeIndexPage({Key? key}) : super(key: key);

  final logic = Get.find<ExchangeIndexLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<ExchangeIndexLogic>(
      appBar: const AppTopBar(
        title: "钻石余额",
      ),
      childBuilder: (s) {
        return AppColumn(
          padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 15.w),
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 150.w,
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
                      return const ExchangeNewPage();
                    } else {
                      return WithdrawPage(commission:logic.commission);
                    }
                  }).toList()),
            )
          ],
        );
      },
    );
  }
}
