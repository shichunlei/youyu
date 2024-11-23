import 'package:youyu/config/api.dart';
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RankSubLogic extends AppBaseController with GetTickerProviderStateMixin {
  // RankSubLogic get to => Get.find<RankSubLogic>(tag: dataModel.id.toString());

  ///外层tab
  late TabModel dataModel;

  ///ta
  late TabController tabController;
  final List<TabModel> tabs = [
    TabModel(id: 1, name: "日榜"),
    TabModel(id: 2, name: "周榜"),
    TabModel(id: 3, name: "月榜"),
    // TabModel(id: 4, name: "总榜"),
  ];

  RxList<TabModel> giftTabs = <TabModel>[].obs;

  @override
  Future<void> onReady() async {
    super.onReady();
    setIsLoading = true;
  }

  Future<void> fetchWeekGiftData() async {
    try {
      var response = await request(AppApi.weekGiftUrl);
      for (var temp in response.data) {
        TabModel gift = TabModel.fromJson(temp);
        if (giftTabs.length < 4) giftTabs.add(gift);
      }
    } catch (e) {
      setErrorType(e);
    }
  }
}
