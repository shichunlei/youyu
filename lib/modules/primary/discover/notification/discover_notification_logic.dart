import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiscoverNotificationLogic extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  ///tab
  late TabController tabController;
  List<TabModel> tabs = [
    TabModel(id: 0, name: "评论"),
    TabModel(id: 1, name: "提到我"),
    TabModel(id: 2, name: "点赞"),
  ];

  var commentUnRead = 0;
  var likeUnRead = 0;
  var atUnRead = 0;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: tabs.length, vsync: this);
    commentUnRead = Get.arguments['commentUnRead'];
    likeUnRead = Get.arguments['likeUnRead'];
    atUnRead = Get.arguments['atUnRead'];

    setSuccessType();
  }
}
