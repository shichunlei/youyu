import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExchangeIndexLogic extends AppBaseController
    with GetSingleTickerProviderStateMixin {
   String? commission;
  ///tab
  late TabController tabController;
  final List<TabModel> tabs = [
    TabModel(id: 1, name: "兑换"),
    TabModel(id: 2, name: "提现"),
  ];

  @override
  void onInit() {
    super.onInit();
    commission = Get.arguments;
    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void onClose() {
    super.onClose();
    tabController.dispose();
  }
}
