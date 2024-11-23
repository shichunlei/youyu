import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/controllers/base/base_controller.dart';


class LivePopUserRankLogic extends AppBaseController
    with GetTickerProviderStateMixin {

  ///外层tab
  late TabModel dataModel;

  ///tab
  late TabController tabController;
  final List<TabModel> tabs = [
    TabModel(id: 1, name: "日榜"),
    TabModel(id: 2, name: "周榜"),
    TabModel(id: 3, name: "月榜"),
  ];

}
