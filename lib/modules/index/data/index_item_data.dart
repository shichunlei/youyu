import 'package:youyu/config/resource.dart';
import 'package:youyu/modules/primary/discover/index/discover_index_view.dart';
import 'package:youyu/modules/primary/home/home_index_view.dart';
import 'package:youyu/modules/primary/message/index/message_index_view.dart';
import 'package:youyu/modules/primary/mine/index/mine_index_view.dart';


import '../model/tabbar_tab_item.dart';

class IndexItemData {

  TabBarItem item1 = TabBarItem(title: "首页",
      isShowRed: false,
      img: AppResource().homeTab,
      selImg: AppResource().homeSelTab,
      page: const HomeIndexPage());

  TabBarItem item2 = TabBarItem(
      title: "发现",
      isShowRed: false,
      img: AppResource().findTab,
      selImg: AppResource().findSelTab,
      page: const DiscoverIndexPage());

  TabBarItem item3 = TabBarItem(
      title: "消息",
      isShowRed: true,
      img: AppResource().msgTab,
      selImg: AppResource().mgsSelTab,
      page: const MessageIndexPage());

  TabBarItem item4 = TabBarItem(
      title: "我的",
      isShowRed: false,
      img: AppResource().mineTab,
      selImg: AppResource().mineSelTab,
      page: const MineIndexPage());

}