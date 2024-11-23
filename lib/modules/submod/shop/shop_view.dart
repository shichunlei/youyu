import 'package:youyu/config/resource.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';

import 'package:youyu/widgets/svga/simple_player_repeat.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/modules/submod/shop/sub/shop_sub_list_view.dart';
import 'package:youyu/modules/submod/shop/widget/tabbar/shop_tab_bar.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:youyu/widgets/app/image/app_circle_net_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'shop_logic.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final logic = Get.find<ShopLogic>();

  final GlobalKey<ShopTabBarState> tabBarKey = GlobalKey<ShopTabBarState>();

  @override
  Widget build(BuildContext context) {
    return AppPage<ShopLogic>(
      appBar: const AppTopBar(
        title: "商城",
      ),
      childBuilder: (s) {
        return AppColumn(
          children: [_banner(), _tabBar(), Expanded(child: _content())],
        );
      },
    );
  }

  _banner() {
    return AppColumn(
      width: double.infinity,
      height: 140.h,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      color: const Color(0xFFDAC9FF),
      children: [
        Obx(() {
          return AppStack(
            width: 140.w,
            height: 88.w,
            alignment: Alignment.center,
            children: [
              if (logic.index.value != 2) //如果是座驾
                if (logic.index.value == 3) //如果是靓号
                  Stack(
                    children: [
                      AppLocalImage(
                          path: AppResource().fancyNumberBg, width: 139.h),
                      Positioned(
                        top: 0,
                        left: 15.w,
                        right: 0,
                        bottom: 0,
                        child: Center(
                          child: Text(
                            logic.curItem.value?.fancyNumber ?? "",
                            style: AppTheme().textStyle(
                                fontSize: 14.sp,
                                color: AppTheme.colorTextWhite),
                          ),
                        ),
                      )
                    ],
                  )
                else
                  AppCircleNetImage(
                    size: 56.h,
                    imageUrl: UserController.to.avatar,
                    borderWidth: 1.w,
                    borderColor: AppTheme.colorMain,
                  ),
              Obx(() => logic.curItem.value != null
                  ? SizedBox(
                      width: 88.w,
                      height: 88.w,
                      child: SVGASimpleImageRepeat(
                        key: UniqueKey(),
                        resUrl: logic.curItem.value?.res,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const SizedBox.shrink())
            ],
          );
        }),
        SizedBox(
          height: 6.h,
        ),
        Obx(() {
          return logic.index.value != 2
              ? Text(
                  UserController.to.nickname,
                  style: AppTheme().textStyle(
                      fontSize: 14.sp, color: const Color(0xFF000000)),
                )
              : const SizedBox.shrink();
        })
      ],
    );
  }

  _tabBar() {
    return ShopTabBar(
        key: tabBarKey, tabs: logic.tabs, controller: logic.tabController);
  }

  _content() {
    return AppColumn(
      children: [
        Expanded(
            child: NotificationListener<ScrollNotification>(
          child: TabBarView(
              controller: logic.tabController,
              children: logic.tabs.map((e) {
                return ShopSubListPage(
                  tabModel: e,
                  curItem: logic.curItem,
                  onRefreshTop: () {
                    setState(() {});
                  },
                );
              }).toList()),
          onNotification: (ScrollNotification scrollNotification) {
            if (scrollNotification is ScrollUpdateNotification &&
                scrollNotification.depth == 0) {
              // 一般页面都是左右滚动
              if (scrollNotification.metrics.axisDirection ==
                  AxisDirection.right) {
                // 滚动百分比，0.0-1.0
                double progress = scrollNotification.metrics.pixels /
                    scrollNotification.metrics.maxScrollExtent;
                double unit = 1.0 / logic.tabs.length;
                int index = progress ~/ unit;
                tabBarKey.currentState?.updateIndex(index);
              }
            }
            return true;
          },
        ))
      ],
    );
  }
}
