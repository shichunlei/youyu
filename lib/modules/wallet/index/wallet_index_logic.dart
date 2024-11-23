
import 'package:youyu/models/localmodel/menu_model.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';

enum WalletListType {
  rechargeRecord, //充值记录
  withdrawRecord, //提现记录
  mochaRecord,    //茶豆记录
  diamondRecord,  //钻石记录
  backpack;       //礼物记录
}

class WalletIndexLogic extends AppBaseController {
  List<MenuModel> itemList = [
    MenuModel(
        type: WalletListType.rechargeRecord,
        title: "充值记录",
        icon: AppResource().walletWithRecharge),
    MenuModel(
        type: WalletListType.withdrawRecord,
        title: "提现记录",
        icon: AppResource().walletWithDraw),
    MenuModel(
        type: WalletListType.mochaRecord,
        title: "茶豆明细",
        icon: AppResource().walletMocha),
    MenuModel(
        type: WalletListType.diamondRecord,
        title: "钻石明细",
        icon: AppResource().walletDiamond),
    MenuModel(
        type: WalletListType.backpack,
        title: "背包礼物账单",
        icon: AppResource().walletWithGift)
  ];

  String? commission;

  @override
  void onInit() {
    super.onInit();
    request(AppApi.walletIndexUrl).then((value) {
      if (value.data != null) {
        var coins = value.data['coins'];
        if (coins is num) {
          UserController.to.userInfo.value?.coins = coins;
        } else {
          UserController.to.userInfo.value?.coins = num.parse(coins);
        }
        var diamonds = value.data['diamonds'];
        if (diamonds is num) {
          UserController.to.userInfo.value?.diamonds = diamonds;
        } else {
          UserController.to.userInfo.value?.diamonds = num.parse(diamonds);
        }
        commission = value.data['commission'];
        setSuccessType();
      }
    });
  }
}
