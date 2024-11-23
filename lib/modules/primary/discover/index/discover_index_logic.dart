
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/router/router.dart';

class DiscoverIndexLogic extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  List<TabModel> tabs = [
    TabModel(id: 1, name: "推荐"),
    TabModel(id: 2, name: "关注")
  ];

  var unReadNum = 0.obs;
  var commentUnRead = 0.obs;
  var likeUnRead = 0.obs;
  var atUnRead = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: tabs.length, vsync: this);
    _fetchUnReadNum();
  }

  ///获取消息未读
  _fetchUnReadNum() {
    request(AppApi.dynamicUnReadNumUrl,isShowToast: false,isPrintLog: false).then((value) {
      unReadNum.value = value.data['all'];
      commentUnRead.value = value.data['comment'];
      likeUnRead.value = value.data['like'];
      atUnRead.value = value.data['mention'];
    });
  }

  ///添加
  onClickAdd() {
    Get.toNamed(AppRouter().discoverPages.discoverPublishRoute.name);
  }

  ///通知
  onClickNotification() {
    Get.toNamed(AppRouter().discoverPages.discoverNotifyRoute.name,
        arguments: {
          "commentUnRead": commentUnRead.value,
          "likeUnRead": likeUnRead.value,
          "atUnRead": atUnRead.value,
        })?.then((value) {
      _fetchUnReadNum();
    });
  }
}
