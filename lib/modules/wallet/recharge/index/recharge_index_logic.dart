import 'package:youyu/config/api.dart';
import 'package:youyu/models/localmodel/item_title_model.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/modules/wallet/recharge/index/dialog/recharge_custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RechargeIndexLogic extends AppBaseController {
  ///金额列表
  List<ItemTitleModel> payInfoList = [];

  //当前选择的金额
  ItemTitleModel? curSelModel;

  //自定义金额
  ItemTitleModel? customModel;

  //是否是自定义金额
  bool isSelCustom = false;

  set setIsSelCustom(bool value) {
    isSelCustom = value;
    if (isSelCustom) {
      curSelModel = null;
    }
    update();
  }


  initPayInfoList() async {
    payInfoList.clear();
    var res = await request(AppApi.userRechargeUrl);
    for (Map<String, dynamic> item in res.data) {
      ItemTitleModel model = ItemTitleModel.fromJson(item);
      payInfoList.add(model);
    }
    update();
    // payInfoList
    //     .add(ItemTitleModel(title: "60", subTitle: "6", extra: "78143204"));
    // payInfoList.add(ItemTitleModel(title: "300", subTitle: "30",extra: "78143205"));
    // payInfoList.add(ItemTitleModel(title: "680", subTitle: "68",extra: "781432066"));
    // // if (PlatformUtils.isAndroid) {
    //   payInfoList.add(ItemTitleModel(title: "1280", subTitle: "128",extra: "78143207"));
    //   payInfoList.add(ItemTitleModel(title: "3280", subTitle: "328",extra: "78143208"));
    //   payInfoList.add(ItemTitleModel(title: "6480", subTitle: "648",extra: "78143209"));
    //   payInfoList.add(ItemTitleModel(title: "9980", subTitle: "998",extra: "78143210"));
    //   payInfoList.add(ItemTitleModel(title: "28880", subTitle: "2888",extra: "78143211"));
    //   payInfoList.add(ItemTitleModel(title: "58880", subTitle: "5888",extra: "78143212"));
    // }
    curSelModel = payInfoList.first;
  }

  ///自定义金额
  showCustomDialog() {
    Get.dialog(
        Center(
          child: RechargeCustomDialog(
            dValue: customModel?.title ?? "",
            onDone: (count, price) {
              customModel = ItemTitleModel(title: count, subTitle: price);
              setIsSelCustom = true;
            },
          ),
        ),
        barrierDismissible: false);
  }

  ///验证
  isVerify() {
    return customModel != null || curSelModel != null;
  }
}
