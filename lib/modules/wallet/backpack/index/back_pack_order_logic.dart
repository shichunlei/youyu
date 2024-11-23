import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackPackOrderLogic extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  ///tab
  late TabController tabController;
  final List<TabModel> tabs = [
    TabModel(id: 1, name: "送出"),
    TabModel(id: 2, name: "获得"),
  ];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void onClose() {
    super.onClose();
    tabController.dispose();
  }
}
