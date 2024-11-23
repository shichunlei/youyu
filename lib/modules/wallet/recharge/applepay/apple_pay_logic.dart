import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/models/localmodel/menu_model.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/modules/wallet/recharge/applepay/iap/ios_pay.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

class ApplePayLogic extends AppBaseController {
  String price = "";
  String productId = "";
  List<MenuModel> payStyleList = [];
  late MenuModel curModel;

  String _orderNo = '';
  bool isGotoPay = false;

  @override
  void onInit() {
    super.onInit();

    price = Get.parameters['price'] ?? "";
    productId = Get.parameters['productId'] ?? "";
    payStyleList.clear();
    payStyleList
        .add(MenuModel(title: "支付宝支付", icon: AppResource().aliPay));
    curModel = payStyleList.first;

    InAppPurchaseStoreKitPlatform.registerPlatform();
    Future.delayed(const Duration(milliseconds: 500), () {
      delayAction();
    });
  }

  delayAction() async {
    //内购监听
    IOSPayment.getOrCreateInstance();
    IOSPayment.instance.startSubscription();
  }

  onPay() {
    showCommit();
    request(AppApi.rechargeUrl,
        params: {'type': 3, 'amount': price,},isHiddenCommitLoading: false).then((value) {
      _orderNo = value.data['order_sn'];
      IOSPayment.instance.isPaying = true;
      IOSPayment.instance.iosStartPay(productId, _orderNo,
          iapCallback: (isSuccess, errorMsg) {
            hiddenCommit();
        Future.delayed(const Duration(seconds: 1), () {
          IOSPayment.instance.isPaying = false;
          UserController.to.updateMyInfo();
        });

      });
    });
  }

  ///选择支付类型
  selectedPayType(model) {
    curModel = model;
    setSuccessType();
  }

  @override
  void onDetached() {}

  @override
  void onInactive() {}

  ///切换到后台
  @override
  void onPaused() {}

  ///切换到前台
  @override
  void onResumed() {
    if (isGotoPay) {
      isGotoPay = false;
      return;
    }
    _checkPayState();
  }

  _checkPayState() {
    if (_orderNo.isNotEmpty) {
      request(AppApi.aliCallBackUrl, params: {'order_no': _orderNo})
          .then((value) {
        _orderNo = '';
        ToastUtils.show("支付成功");
        UserController.to.updateMyInfo();
        Get.back();
      }).catchError((e) {
        _orderNo = '';
      });
    }
  }
}
