import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageIndexLogic extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  List<TabModel> tabs = [
    TabModel(id: 0, name: "聊天"),
    TabModel(id: 1, name: "联系人")
  ];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: tabs.length, vsync: this);
  }

}
