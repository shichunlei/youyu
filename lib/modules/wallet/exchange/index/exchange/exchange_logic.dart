import 'package:youyu/utils/toast_utils.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExchangeLogic extends AppBaseController {
  //钻数量
  TextEditingController diamondController = TextEditingController();

  //金豆数量
  FocusNode diamondFocusNode = FocusNode();

  var coin = 0.obs;

  @override
  void onInit() {
    super.onInit();
    diamondController.addListener(() {
      _calculateExchange();
    });
  }

  ///计算兑换茶豆
  _calculateExchange() {
    cancelRequest();
    if (diamondController.text.isNotEmpty && diamondController.text.isNum) {
      setIsLoading = true;
      request(AppApi.calculateExchangeUrl,
          params: {'number': diamondController.text}).then((value) {
        setIsLoading = false;
        coin.value = value.data;
      }).catchError((e) {
        setIsLoading = false;
      });
    } else {
      coin.value = 0;
    }
  }

  ///兑换
  exchange() async {
    if (diamondController.text.isNum) {
      showCommit();
      request(AppApi.walletExchangeUrl,
          params: {'number': diamondController.text}).then((value) {
        UserController.to.updateMyInfo();
        diamondController.text = "";
        ToastUtils.show("兑换成功");
      });
    } else {
      ToastUtils.show('请输入正确的数量');
    }
  }

  isVerify() => (diamondController.text.isNotEmpty);

  @override
  void onClose() {
    super.onClose();
    diamondFocusNode.dispose();
  }
}
