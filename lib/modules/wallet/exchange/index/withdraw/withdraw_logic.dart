import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/modules/wallet/exchange/bean/account_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/router/router.dart';

class WithdrawLogic extends AppBaseController {
  //金额
  TextEditingController moneyController = TextEditingController();
  FocusNode moneyFocusNode = FocusNode();
  AccountModel? accountModel;

  var isVerify = false.obs;

  @override
  void onInit() {
    super.onInit();
    setNoneType();
    moneyController.addListener(() {
      isVerify.value =
          (moneyController.text.isNotEmpty && accountModel != null);
    });

    _loadData();
  }

  _loadData() {
    setIsLoading = true;
    request(AppApi.walletIsAccountUrl).then((value) {
      if (value.data['is_account'] == 1) {
        accountModel = AccountModel(
            account: value.data['account'], name: value.data['name']);
      }
      setSuccessType();
    }).catchError((e) {
      setErrorType(e);
    });
  }

  ///进入账户页面
  pushToAccount() {
    Get.toNamed(AppRouter().walletPages.withDrawIndexRoute.name,
            arguments: accountModel)
        ?.then((value) {
      _loadData();
    });
  }

  ///提现
  withdraw() async {
    if (isVerify()) {
      try {
        showCommit();
        await request(AppApi.walletCommitUrl,
            params: {'type': 1, 'money': moneyController.text});
        UserController.to.updateMyInfo();
        ToastUtils.show("提现成功");
        moneyController.clear();
      } catch (e) {
        hiddenCommit();
      }
    }
  }

  @override
  void reLoadData() {
    super.reLoadData();
    _loadData();
  }
}
