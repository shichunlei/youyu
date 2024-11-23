/*
 * @Author: alexalive hhyy1243047559@gmail.com
 * @Date: 2024-10-13 20:45:41
 * @LastEditors: alexalive hhyy1243047559@gmail.com
 * @LastEditTime: 2024-11-02 16:29:24
 * @FilePath: /youyu/lib/modules/submod/rank/rank_index_logic.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RankIndexLogic extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  var currentIndex = 0.obs;

  ///tab
  late TabController tabController;
  List<TabModel> tabs = [
    TabModel(id: 1, name: "财富榜"),
    TabModel(id: 2, name: "魅力榜"),
    TabModel(id: 3, name: "CP榜"),
    TabModel(id: 4, name: "周星榜"),
  ];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: tabs.length, vsync: this);
  }

  updateIndex(int index) {
    if (index != currentIndex.value && index < tabs.length) {
      currentIndex.value = index;
    }
  }
}
