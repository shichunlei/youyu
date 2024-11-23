import 'package:card_swiper/card_swiper.dart';
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/modules/submod/vip/model/vip_index_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VipLogic extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  ///swiper
  final SwiperController tzController = SwiperController();

  ///cards
  final List<VipCardModel> cardList = [];

  ///tab
  var currentIndex = 0.obs;
  List<TabModel<bool>> tabs = [];
  TabController? tabController;

  ///颜色
  static Color textColor(bool isSVip) {
    return isSVip ? const Color(0xFFFE694B) : const Color(0xFFF48815);
  }

  static Color borderColor(bool isSVip) {
    return isSVip ? const Color(0xFFFFAAA5) : const Color(0xFFF48815);
  }

  @override
  void onInit() {
    super.onInit();
    cardList.addAll([
      VipCardModel(
          headUrl: UserController.to.avatar,
          userName: UserController.to.nickname,
          subTitle: "开通VIP会员，立享更多特权",
          isSVip: true),
      VipCardModel(
          headUrl: UserController.to.avatar,
          userName: UserController.to.nickname,
          subTitle: "开通VIP会员，立享更多特权",
          isSVip: false),
    ]);

    for (int i = 0; i < cardList.length; i++) {
      tabs.add(TabModel(name: "", id: i, customExtra: cardList[i].isSVip));
    }
    tabController = TabController(length: tabs.length, vsync: this);
  }

  swiperTouchIndex(int index) {
    if (index != currentIndex.value && index < tabs.length) {
      tabController?.index = index;
      currentIndex.value = index;
    }
  }

  @override
  void onClose() {
    tzController.dispose();
    super.onClose();
  }
}
