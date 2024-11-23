import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:flutter/material.dart';

class LivePopUserOnLineLogic extends AppBaseController {
  //原数据
  List<UserInfo> oriDataList = [];

  //数据
  List<UserInfo> dataList = [];

  //控制器
  final TextEditingController controller = TextEditingController();

  fetchData(List<UserInfo> dataList) {
    oriDataList.addAll(dataList);
    this.dataList.addAll(dataList);
    if (dataList.isEmpty) {
      isNoData = true;
    } else {
      isNoData = false;
    }
    setSuccessType();
  }

  ///清除搜索按钮
  onClickClear() {
    //...
  }

  ///搜索提交
  onSubmitted() {
    dataList.clear();
    if (controller.text.isEmpty) {
      dataList.addAll(oriDataList);
    } else {
      for (UserInfo info in oriDataList) {
        if (info.fancyNumber.toString().contains(controller.text) ||
            (info.nickname ?? "").contains(controller.text)) {
          dataList.add(info);
        }
      }
    }
    if (dataList.isEmpty) {
      isNoData = true;
    } else {
      isNoData = false;
    }
    setSuccessType();
  }
}
