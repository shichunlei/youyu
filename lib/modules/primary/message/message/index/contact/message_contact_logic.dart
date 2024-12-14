import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/controllers/base/base_controller.dart';

class MessageContactLogic extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  List<TabModel> tabs = [
    TabModel(id: 3, name: "好友"),
    TabModel(id: 1, name: "关注"),
    TabModel(id: 2, name: "粉丝")
  ];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: tabs.length, vsync: this);
    tabController.addListener(() {
      closeKeyboard();
    });
  }
}
