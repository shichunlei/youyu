import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../message/live_message.dart';
import 'list/live_screen_list_logic.dart';

class LiveScreenLogic extends AppBaseController
    with GetSingleTickerProviderStateMixin {
  late String pageTag;

  ///tab
  late TabController tabController;

  List<TabModel> tabs = [];

  ///sub logic
  late LiveScreenListLogic listLogic1 =
      Get.find<LiveScreenListLogic>(tag: tabs[0].id.toString() + pageTag);
  late LiveScreenListLogic listLogic2 =
      Get.find<LiveScreenListLogic>(tag: tabs[1].id.toString() + pageTag);
  late LiveScreenListLogic listLogic3 =
      Get.find<LiveScreenListLogic>(tag: tabs[2].id.toString() + pageTag);

  createTabs() {
    if (LiveService().isOpenScreenTab) {
      tabs.addAll([
        TabModel(id: 0, name: "全部"),
        TabModel(id: 1, name: "聊天"),
        TabModel(id: 2, name: "礼物"),
      ]);
    } else {
      tabs.add(TabModel(id: 0, name: "全部"));
    }
    tabController = TabController(length: tabs.length, vsync: this);
    for (TabModel tabModel in tabs) {
      Get.put<LiveScreenListLogic>(LiveScreenListLogic(),
          tag: tabModel.id.toString() + pageTag);
    }
  }

  ///插入消息
  insertMessage(LiveMessageModel model) {
    listLogic1.insertMessage(model,0);
    if (LiveService().isOpenScreenTab) {
      if (model.type == LiveMessageType.text) {
        listLogic2.insertMessage(model,1);
      }
      if (model.type == LiveMessageType.gift) {
        listLogic3.insertMessage(model,2);
      }
    }
  }

  ///清屏
  clearAllMessage() {
    listLogic1.clearAllMessage(0);
    if (LiveService().isOpenScreenTab) {
      listLogic2.clearAllMessage(1);
      listLogic3.clearAllMessage(2);
    }
  }

  ///处理遮罩
  processMaskType(LiveScreenMaskType maskType) {
    listLogic1.processMaskType(maskType);
    if (LiveService().isOpenScreenTab) {
      listLogic2.processMaskType(maskType);
      listLogic3.processMaskType(maskType);
    }
  }
}
