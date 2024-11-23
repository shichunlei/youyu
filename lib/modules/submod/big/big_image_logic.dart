import 'package:youyu/controllers/base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BigImageLogic extends AppBaseController {

  String itemTag = "";
  late int curIndex;
  late List<String>imageList;
  PageController? pageController;

  @override
  void onInit() {
    super.onInit();
    itemTag = Get.arguments["itemTag"];
    curIndex = Get.arguments["index"];
    imageList = Get.arguments["list"];
    pageController = PageController(initialPage: curIndex);

  }

}
