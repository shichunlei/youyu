import 'package:youyu/modules/wallet/backpack/index/back_pack_order_binding.dart';
import 'package:youyu/modules/wallet/backpack/index/back_pack_order_view.dart';
import 'package:youyu/modules/wallet/exchange/add/change/with_draw_account_change_binding.dart';
import 'package:youyu/modules/wallet/exchange/add/change/with_draw_account_change_view.dart';
import 'package:youyu/modules/wallet/exchange/add/detail/with_draw_account_add_binding.dart';
import 'package:youyu/modules/wallet/exchange/add/detail/with_draw_account_add_view.dart';
import 'package:youyu/modules/wallet/exchange/add/index/with_draw_account_binding.dart';
import 'package:youyu/modules/wallet/exchange/add/index/with_draw_account_view.dart';
import 'package:youyu/modules/wallet/exchange/index/exchange_index_binding.dart';
import 'package:youyu/modules/wallet/exchange/index/exchange_index_view.dart';
import 'package:youyu/modules/wallet/index/wallet_index_binding.dart';
import 'package:youyu/modules/wallet/index/wallet_index_view.dart';
import 'package:youyu/modules/wallet/recharge/applepay/apple_pay_binding.dart';
import 'package:youyu/modules/wallet/recharge/applepay/apple_pay_view.dart';
import 'package:youyu/modules/wallet/recharge/index/recharge_index_binding.dart';
import 'package:youyu/modules/wallet/recharge/index/recharge_index_view.dart';
import 'package:youyu/modules/wallet/recharge/pay/pay_binding.dart';
import 'package:youyu/modules/wallet/recharge/pay/pay_view.dart';
import 'package:youyu/modules/wallet/record/record_index_binding.dart';
import 'package:youyu/modules/wallet/record/record_index_view.dart';
import 'package:get/get.dart';

class WalletPages {
  ///钱包
  GetPage walletRoute = GetPage(
    name: '/wallet',
    bindings: [
      WalletIndexBinding(),
    ],
    page: () => const WalletIndexPage(),
  );

  ///充值
  GetPage rechargeRoute = GetPage(
    name: '/recharge',
    bindings: [
      RechargeIndexBinding(),
    ],
    page: () => const RechargeIndexPage(),
  );

  ///支付
  GetPage payRoute = GetPage(
    name: '/pay',
    bindings: [
      PayBinding(),
    ],
    page: () => PayPage(),
  );

  ///苹果支付
  GetPage applePayRoute = GetPage(
    name: '/applyPay',
    bindings: [
      ApplePayBinding(),
    ],
    page: () => ApplePayPage(),
  );

  ///兑换
  GetPage exchangeRoute = GetPage(
    name: '/exchange',
    bindings: [
      ExchangeIndexBinding(),
    ],
    page: () => ExchangeIndexPage(),
  );

  ///提现
  GetPage withDrawIndexRoute = GetPage(
    name: '/withDraw',
    bindings: [
      WithDrawAccountBinding(),
    ],
    page: () => WithDrawAccountPage(),
  );

  ///添加账号
  GetPage withDrawAccountAddRoute = GetPage(
    name: '/withDrawAdd',
    bindings: [
      WithDrawAccountAddBinding(),
    ],
    page: () => const WithDrawAccountAddPage(),
  );

  ///更换账号
  GetPage withDrawAccountChangeRoute = GetPage(
    name: '/withDrawChange',
    bindings: [
      WithDrawAccountChangeBinding(),
    ],
    page: () => const WithDrawAccountChangePage(),
  );

  ///充值记录 & 提现记录 & 茶豆明细 & 钻石明细
  GetPage recordIndexRoute = GetPage(
    name: '/recordIndex',
    bindings: [
      RecordIndexBinding(),
    ],
    page: () => const RecordIndexPage(),
  );

  ///背包礼物账单
  GetPage backPackOrderRoute = GetPage(
    name: '/backPackOrder',
    bindings: [
      BackPackOrderBinding(),
    ],
    page: () => BackPackOrderPage(),
  );
}
