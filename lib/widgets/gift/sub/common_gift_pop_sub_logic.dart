import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/widgets/app/app_default.dart';
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/gift_controller.dart';
import 'package:youyu/models/gift.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonGiftPopSubLogic extends AppBaseController {
  //一页有8条
  int pageItemCount = 12;

  //每页礼物列表
  List<List<Gift>> giftList = [];

  //选择的礼物id
  var selectedGiftId = 0.obs;

  //tab
  late TabModel<List<Gift>> tabModel;
  late int tabIndex;

  fetchGiftList(Function(Gift defaultGift) onCallBack) async {
    setIsLoading = true;
    List<Gift> allList;
    if (tabModel.id != GiftController.backPackId) {
      //礼物列表保存在了这里
      allList = tabModel.customExtra ?? [];
    } else {
      allList = await GiftController.to.fetchBackPack();
    }

    setIsLoading = false;
    if (allList.isNotEmpty) {
      List<Gift> tempList = [];
      for (var gift in allList) {
        tempList.add(gift);
        if (tempList.length == pageItemCount) {
          giftList.add(tempList);
          tempList = [];
        }
      }
      if (tempList.isNotEmpty) {
        giftList.add(tempList);
      }

      ///默认选中第一个
      if (giftList.isNotEmpty) {
        selectedGiftId.value = giftList.first.first.id ?? 0;
        onCallBack(giftList.first.first);
      }
      setSuccessType();
    } else {
      setEmptyType(
          defaultConfig: AppDefaultConfig.defaultConfig(loadType,
              msg: "暂无礼物", margin: EdgeInsets.only(top: 35.h), size: 72.h));
    }
  }

  @override
  void onClose() {
    giftList.clear();
    super.onClose();
  }
}
