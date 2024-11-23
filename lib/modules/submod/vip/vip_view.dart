import 'package:youyu/utils/screen_utils.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:youyu/modules/submod/vip/model/vip_index_model.dart';
import 'package:youyu/modules/submod/vip/sub/vip_sub_list_view.dart';
import 'package:youyu/modules/submod/vip/widget/vip_card_widget.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'vip_logic.dart';

class VipPage extends StatelessWidget {
  VipPage({Key? key}) : super(key: key);

  final logic = Get.find<VipLogic>();

  @override
  Widget build(BuildContext context) {
    return AppPage<VipLogic>(
      appBar: const AppTopBar(
        title: "会员中心",
      ),
      childBuilder: (s) {
        return AppColumn(
          margin: EdgeInsets.only(top: 10.h),
          children: [_banner(), Expanded(child: _tabView())],
        );
      },
    );
  }

  //banner
  _banner() {
    return SizedBox(
      width: double.infinity,
      height: 160.h,
      child: Swiper(
        scrollDirection: Axis.horizontal,
        // 横向
        itemCount: logic.cardList.length,
        autoplay: false,
        loop: false,
        controller: logic.tzController,
        onIndexChanged: (index) {
          logic.swiperTouchIndex(index);
        },
        // 自动翻页
        itemBuilder: (BuildContext context, int index) {
          VipCardModel model = logic.cardList[index];
          return VipCardWidget(
            model: model,
            height: 160.h,
          );
        },
      ),
    );
  }

  //tabPage
  _tabView() {
    return TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: logic.tabController,
        children: logic.tabs.map((e) {
          return VipSubListPage(
            tabModel: e,
          );
        }).toList());
  }
}
