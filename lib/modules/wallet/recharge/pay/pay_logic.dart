import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';
import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/models/localmodel/menu_model.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:fluwx/fluwx.dart';
import 'package:get/get.dart';
import 'package:alipay_kit/alipay_kit.dart';

enum PayType { wx, ali }

class PayLogic extends AppBaseController {
  String price = "";
  List<MenuModel> payStyleList = [];
  late MenuModel curModel;

  final Fluwx _fluwx = Fluwx();

  String _orderNo = '';
  bool isGotoPay = false;

  @override
  void onInit() {
    super.onInit();

    price = Get.parameters['price'] ?? "";
    payStyleList.clear();
    payStyleList.add(MenuModel(
        type: PayType.ali, title: "支付宝支付", icon: AppResource().aliPay));
    // payStyleList.add(
    //     MenuModel(type: PayType.wx, title: "微信支付", icon: AppResource().wxPay));
    curModel = payStyleList.first;

    //监听支付回调
    _observePayState();
  }

  ///选择支付类型
  selectedPayType(model) {
    curModel = model;
    setSuccessType();
  }

  ///支付
  pay() async {
    showCommit();
    request(AppApi.rechargeUrl, params: {
      'type': curModel.type == PayType.ali ? 1 : 2,
      'amount': price
    }).then((value) {
      if (curModel.type == PayType.wx) {
        // _wxPay(null);
        isGotoPay = true;
        _wxMiniPay(value.data['return']['data']);
      } else if (curModel.type == PayType.ali) {
        isGotoPay = true;
        // _orderNo = value.data['order_sn'];
        // _aliPay(value.data['return']['data']);
        _aliPay2(value.data['return']['data']);
      }
    });
  }

  pay2() async {
    showCommit();
    request(AppApi.planTest, params: {
      'type': curModel.type == PayType.ali ? 1 : 2,
      'amount': price
    }).then((value) {
      _wxMiniPay(value.data);
    });
  }

  //微信支付
  _wxPay(result) {
    _fluwx.registerApi(
        appId: "your Appid", universalLink: " your univerallink ");
    _fluwx.pay(
        which: Payment(
      appId: result['appid'],
      partnerId: result['partnerid'],
      prepayId: result['prepayid'],
      packageValue: result['package'],
      nonceStr: result['noncestr'],
      // 此处为 int 格式，如果后端返回的int格式则不需要进行额外处理
      timestamp: int.parse(result['timestamp']),
      sign: result['sign'],
    ));
  }

  //跳转小程序支付
  _wxMiniPay(result) async {
    final Map<String, dynamic> data = jsonDecode(result['miniapp_data']);
    Uri uri = Uri.parse(data['scheme_code'] ?? "");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    //TODO:test
    //  _fluwx.registerApi(
    //      appId: "wx11361ccf7f47b948", universalLink: "");
    //  String username = data['gh_id'] as String;
    //  String path = data['path'] as String;
    //  path = "$path?p=${result["pre_order_id"]}&s=app";
    //  _fluwx.open(
    //      target: MiniProgram(
    //        username: username,
    //        path: path,
    //        miniProgramType: WXMiniProgramType.release,
    //      ));
  }

  _aliPay2(result) async {
    String data = result['jump_url'];
    Uri uri = Uri.parse(data);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  //支付宝支付
  ///支付宝支付
  _aliPay(String data) {
    AlipayKitPlatform.instance.pay(orderInfo: data, dynamicLaunch: true);
  }

  ///监听支付回调
  _observePayState() {
    //微信支付回调
    FluwxCancelable? cancelable;
    cancelable = _fluwx.addSubscriber((res) => {
          if (res.errCode == 0)
            {
              // 这里建议去额外让后端处理支付结果回调
              cancelable?.cancel(),
              ToastUtils.show("支付成功")
            }
        });
  }

  // void _listenPay(AlipayResp resp) {
  //   final String content = 'pay: ${resp.resultStatus} - ${resp.result}';
  //   if (resp.resultStatus == 9000) {
  //     ToastUtils.show("支付成功");
  //     UserController.to.updateMyInfo();
  //   } else {
  //     ToastUtils.show("支付失败");
  //   }
  //
  // }

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
