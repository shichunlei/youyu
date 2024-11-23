import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/modules/wallet/exchange/bean/account_model.dart';
import 'package:youyu/widgets/app/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithDrawAccountLogic extends AppBaseController {
  AccountModel? accountModel;
  GlobalKey<AppTopBarState> navKey = GlobalKey<AppTopBarState>();

  @override
  void onInit() {
    super.onInit();
    accountModel = Get.arguments;
    if (accountModel != null) {
      navKey.currentState?.updateTitle(newTitle: "更换账号");
    } else {
      navKey.currentState?.updateTitle(newTitle: "添加账号");
    }
  }
}
