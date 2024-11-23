import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/modules/live/common/notification/live_setting_notify.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveSettingBlackLogic extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  late int roomId;
  late LiveSettingNotify settingNotify;
  ///tab
  late TabController tabController;
  final List<TabModel> tabs = [
    TabModel(id: 1, name: "禁言列表"),
    TabModel(id: 2, name: "踢出列表"),
  ];

  @override
  void onInit() {
    super.onInit();
    roomId = Get.arguments['roomId'];
    settingNotify = Get.arguments['settingNotify'];
    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void onClose() {
    super.onClose();
    tabController.dispose();
  }
}
