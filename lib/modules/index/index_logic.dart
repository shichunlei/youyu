import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/toast_utils.dart';
import 'package:youyu/controllers/app_controller.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/modules/index/widget/index_page_widget.dart';
import 'package:youyu/widgets/app/icon/app_un_read_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'data/index_item_data.dart';
import 'model/tabbar_tab_item.dart';

class IndexLogic extends AppBaseController {
  final PageController pageController = PageController();

  static int tabId = 1;

  ///当前页面索引
  int currentIndex = 0;

  ///记录时间
  int _lastExitTime = 0;

  ///data
  final IndexItemData _itemData = IndexItemData();

  ///tabItems
  final List<TabBarItem> tabItems = [];

  ///pages
  final List<IndexWidget> pages = [];

  ///navigationBarItems
  final List<BottomNavigationBarItem> tabBarList = [];

  @override
  void onInit() {
    super.onInit();
    //items
    tabItems.add(_itemData.item1);
    tabItems.add(_itemData.item2);
    tabItems.add(_itemData.item3);
    tabItems.add(_itemData.item4);
    //pages
    pages.add(_itemData.item1.page);
    pages.add(_itemData.item2.page);
    pages.add(_itemData.item3.page);
    pages.add(_itemData.item4.page);
  }

  //tab点击
  selectedTabBarIndex(int index) {
    //设置索引
    currentIndex = index;
    update([tabId]);
    //跳转页面
    pageController.jumpToPage(index);
  }

  //TODO:获取底部tabBar
  List<BottomNavigationBarItem> getBarItem() {
    if (tabBarList.isEmpty) {
      for (int i = 0; i < tabItems.length; i++) {
        TabBarItem element = tabItems[i];
        tabBarList.add(BottomNavigationBarItem(
            icon: Container(
              width: element.width + 30.w,
              margin: EdgeInsets.only(bottom: element.imgMarginBottom),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 2.h),
                    child: Image(
                        width: element.width,
                        height: element.height,
                        image: AssetImage(element.img ?? "")),
                  ),
                  //红点
                  Obx(() =>
                      (AppController.to.unMsgRedCount > 0 && element.isShowRed)
                          ? Positioned(
                              top: 0,
                              right: 0,
                              child: AppUnReadIcon(
                                number: AppController.to.unMsgRedCount,
                                padding: EdgeInsets.all(3.w),
                              ))
                          : Container())
                ],
              ),
            ),
            activeIcon: Container(
              width: element.width + 30.w,
              margin: EdgeInsets.only(bottom: element.imgMarginBottom),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 2.h),
                    child: Image(
                        width: element.width,
                        height: element.height,
                        image: AssetImage(element.selImg ?? "")),
                  ),
                  //红点
                  Obx(() =>
                      (AppController.to.unMsgRedCount > 0 && element.isShowRed)
                          ? Positioned(
                              top: 0,
                              right: 0,
                              child: AppUnReadIcon(
                                number: AppController.to.unMsgRedCount,
                                padding: EdgeInsets.all(3.w),
                              ))
                          : Container())
                ],
              ),
            ),
            label: element.title()));
      }
    }

    return tabBarList;
  }

  ///再按一次退出app
  Future<bool> exitVerify() async {
    final int nowExitTime = DateTime.now().millisecondsSinceEpoch;

    if (nowExitTime - _lastExitTime > 1000) {
      _lastExitTime = nowExitTime;
      ToastUtils.show("再按一次退出");

      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
