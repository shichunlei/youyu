import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/models/shop_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BagLogic extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  ///tab
  late TabController tabController;
  List<TabModel> tabs = [
    TabModel(id: 1, name: "头像框"),
    // TabModel(id: 2, name: "气泡框"),
    TabModel(id: 3, name: "麦位音波"),
    TabModel(id: 4, name: "座驾"),
    TabModel(id: 5, name: "靓号"),
  ];

  Rx<ShopItem?> curItem = Rx(null);

  RxInt index = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: tabs.length, vsync: this);
    tabController.addListener(() {
      if (index != tabController.index) {
        index.value = tabController.index;
        curItem.value = null;
      }
    });
  }
}
