
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/router/router.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeIndexLogic extends AppBaseController
    with GetSingleTickerProviderStateMixin {

  ///tab
  late TabController homeTabController;
  RxList<TabModel> tabs = <TabModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    setNoneType();
    _requestData();
  }

  _requestData() async {
    setIsLoading = true;
    request(AppApi.homeIndexTypeUrl, isPrintLog: true).then((value) {
      var list = value.data as List<dynamic>;
      homeTabController = TabController(length: list.length, vsync: this);
      List<TabModel> modelList = [];
      for (int i = 0; i < list.length; i++) {
        TabModel model = TabModel.fromJson(list[i]);
        modelList.add(model);
      }
      tabs.value = modelList;
      setSuccessType();
    }).catchError((e) {
      setErrorType(e);
    });
  }

  ///切换顶部tap
  changeTabIndex(int index) {
    homeTabController.animateTo(index);
  }

  ///事件
  //搜索
  onClickSearch() {
    Get.toNamed(AppRouter().otherPages.searchRoute.name);
  }

  //排行榜
  onClickRank() {
    Get.toNamed(AppRouter().otherPages.rankIndexRoute.name);
  }

  //创建直播间
  onClickCreate() {
    LiveService().pushToMyLive();
  }

  @override
  void reLoadData() {
    super.reLoadData();
    _requestData();
  }
}
