import 'dart:async';

import 'package:card_swiper/card_swiper.dart';

import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/user_nobility.dart';
import 'package:youyu/modules/submod/user/nobility/model/nobility_page_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NobilityLogic extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  ///tab
  var currentIndex = 0.obs;
  List<TabModel<NobilityPageModel>> tabs = [];
  TabController? tabController;

  ///当前自己的爵位
  UserNobilityModel? curModel = UserController.to.nobilityControl.myCurNobilityModel();

  ///swiper
  final SwiperController tzController = SwiperController();
  bool _isTouching = false;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    tabs.addAll(getNobilityList());
    tabController = TabController(length: tabs.length, vsync: this);
  }

  ///爵位
  List<TabModel<NobilityPageModel>> getNobilityList() {
    List<NobilityEquityModel> equityList = [
      NobilityEquityModel(
          title: "爵位标识",
          subTitle: "尊享特殊标识",
          image: AppResource().nobilityEquity1),
      NobilityEquityModel(
          title: "升级全服广播",
          subTitle: "全服公告通知",
          image: AppResource().nobilityEquity2),
      NobilityEquityModel(
          title: "发言光圈",
          subTitle: "发言特权光圈",
          image: AppResource().nobilityEquity3),
      NobilityEquityModel(
          title: "聊天气泡",
          subTitle: "专属聊天气泡框",
          image: AppResource().nobilityEquity4),
      NobilityEquityModel(
          title: "头像框",
          subTitle: "专属头像框",
          image: AppResource().nobilityEquity5),
      NobilityEquityModel(
          title: "炫酷坐骑",
          subTitle: "进场炫酷坐骑",
          image: AppResource().nobilityEquity6),
    ];

    List<TabModel<NobilityPageModel>> list = [];
    for (int i = 0; i < UserController.to.nobilityControl.nobilityList.length; i++) {
      UserNobilityModel model =
      UserController.to.nobilityControl.nobilityList[i];
      list.add(TabModel(
          name: "",
          id: i,
          customExtra:
          NobilityPageModel(nobility: model, equityList: equityList)));
    }
    return list;
  }

  tabTouchIndex(int index) {
    if (_isTouching) {
      return;
    }
    _isTouching = true;
    if (index != currentIndex.value && index < tabs.length) {
      if ((tzController.index - index).abs() > 1) {
        tzController.move(index,animation: true);
      } else {
        tzController.move(index, animation: true);
      }
      currentIndex.value = index;
    }
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 200), () {
      _isTouching = false;
    });

  }

  swiperTouchIndex(int index) {
    if (_isTouching) {
      return;
    }
    _isTouching = true;
    if (index != currentIndex.value && index < tabs.length) {
      tabController?.index = index;
      currentIndex.value = index;
    }
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 200), () {
      _isTouching = false;
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    tabController?.dispose();
    tzController.dispose();
    super.onClose();
  }
}
