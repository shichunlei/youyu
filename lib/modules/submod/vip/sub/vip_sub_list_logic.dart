
import 'package:youyu/models/localmodel/menu_model.dart';
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/modules/submod/vip/model/vip_index_model.dart';
import 'package:youyu/modules/wallet/recharge/pay/pay_logic.dart';

class VipSubListLogic extends AppBaseController {
  late TabModel<bool> tabModel;

  ///prices
  List<VipPriceModel> priceList = [];
  VipPriceModel? selPriceModel;

  ///types
  List<MenuModel> typeList = [];
  MenuModel? selTypeModel;

  ///mores
  List<VipMoreModel> moreVipList = [];
  List<VipMoreModel> moreSVipList = [];

  fetchData() {
    //价格
    priceList.addAll([
      VipPriceModel(
          title: "连续包月首页", price: "25", oriPrice: "35", tip: "次月￥25续费\n可随时取消"),
      VipPriceModel(
          title: "连续包季首季", price: "88", oriPrice: "98", tip: "次月￥88续费\n可随时取消"),
      VipPriceModel(
          title: "连续包季首季",
          price: "298",
          oriPrice: "348",
          tip: "次月￥298续费\n可随时取消"),
      VipPriceModel(title: "包月", price: "38", oriPrice: "", tip: "")
    ]);
    //支付方式
    typeList.addAll([
      MenuModel(
          type: PayType.ali, title: "支付宝支付", icon: AppResource().aliPay2),
      MenuModel(
          type: PayType.wx, title: "微信支付", icon: AppResource().wxPay2)
    ]);
    //更多
    moreSVipList.addAll([
      VipMoreModel(isSVip: true,title: "功能特权", subTitle: "共计4项特权", list: [
        MenuModel(
            title: "私聊撤回",
            subTitle: "私聊两分钟内撤回",
            icon: AppResource().vipSFunc1),
        MenuModel(
            title: "动态头像",
            subTitle: "吸睛动态头像",
            icon: AppResource().vipSFunc2),
        MenuModel(
            title: "等级加速",
            subTitle: "成长值加速1.05倍",
            icon: AppResource().vipSFunc3),
        MenuModel(
            title: "照片墙",
            subTitle: "更多照片墙存放",
            icon: AppResource().vipSFunc4)
      ]),
      VipMoreModel(isSVip: true,title: "隐私特权", subTitle: "共计1项特权", list: [
        MenuModel(
            title: "谁看过我",
            subTitle: "掌握谁对我感兴趣",
            icon: AppResource().vipSP1)
      ]),
      VipMoreModel(isSVip: true,title: "身份特权", subTitle: "共计2项特权", list: [
        MenuModel(
            title: "会员标识", subTitle: "尊享特殊标识", icon: AppResource().vipST1),
        MenuModel(
            title: "昵称变色", subTitle: "彩色昵称颜色", icon: AppResource().vipST2)
      ])
    ]);
    moreVipList.addAll([
      VipMoreModel(isSVip: false,title: "功能特权", subTitle: "共计4项特权", list: [
        MenuModel(
            title: "私聊撤回",
            subTitle: "私聊两分钟内撤回",
            icon: AppResource().vipFunc1),
        MenuModel(
            title: "动态头像",
            subTitle: "吸睛动态头像",
            icon: AppResource().vipFunc2),
        MenuModel(
            title: "等级加速",
            subTitle: "成长值加速1.05倍",
            icon: AppResource().vipFunc3),
        MenuModel(
            title: "照片墙",
            subTitle: "更多照片墙存放",
            icon: AppResource().vipFunc4)
      ]),
      VipMoreModel(isSVip: false,title: "隐私特权", subTitle: "共计1项特权", list: [
        MenuModel(
            title: "谁看过我", subTitle: "掌握谁对我感兴趣", icon: AppResource().vipP1)
      ]),
      VipMoreModel(isSVip: false,title: "身份特权", subTitle: "共计2项特权", list: [
        MenuModel(
            title: "会员标识", subTitle: "尊享特殊标识", icon: AppResource().vipT1),
        MenuModel(
            title: "昵称变色", subTitle: "彩色昵称颜色", icon: AppResource().vipT2)
      ])
    ]);

    //默认选中
    selPriceModel = priceList.first;
    selTypeModel = typeList.first;
    setSuccessType();
  }

  ///选择价格
  onClickPrice(VipPriceModel model) {
    selPriceModel = model;
    setSuccessType();
  }

  ///选择支付方式
  onClickType(MenuModel model) {
    selTypeModel = model;
    setSuccessType();
  }
}
