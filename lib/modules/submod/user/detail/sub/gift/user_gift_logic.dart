import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/models/gift.dart';
import 'package:youyu/modules/submod/user/detail/sub/gift/pop/user_gift_pop.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserGiftLogic extends AppBaseController {
  late int userId;
  int allCount = 0;
  List<Gift> dataList = [];

  @override
  void onInit() {
    super.onInit();
    setNoneType();
  }

  ///获取列表
  fetchList() {
    setIsLoading = true;
    request(AppApi.userGiftWallUrl,
        params: {"type": "1", "sort": "1", "user_id": userId}).then((value) {
      allCount = value.data['all_count'];
      List<dynamic> list = value.data['list'];
      for (Map<String, dynamic> map in list) {
        Gift entity = Gift.fromJson(map);
        dataList.add(entity);
      }
      isNoData = dataList.isEmpty;
      setSuccessType();
    }).catchError((e) {
      setErrorType(e);
    });
  }

  ///点击礼物
  onClickGift(Gift itemModel) {
    Get.dialog(Center(
      child: UserGiftPop(
        itemModel: itemModel,
      ),
    ));
  }

  @override
  void reLoadData() {
    super.reLoadData();
    fetchList();
  }
}
