
import 'package:youyu/models/localmodel/menu_model.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/conference.dart';
import 'package:youyu/router/router.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:get/get.dart';
import 'package:youyu/utils/toast_utils.dart';

enum MineIndexMenuType {
  friend, //好友
  followLive, //关注直播间
  visit, //访客
  level, //等级
  jw, //爵位
  wallet, //钱包
  room, //我的房间
  conference, //公会
  shop, //商城
  bag, //背包
  invite, //邀请好友
  service, //在线客服
  children, //强少年模式
  real, //实名认证
  setting, //设置
  feed //意见反馈
}

class MineIndexLogic extends AppBaseController {
  ///核心区域
  List<MenuModel> coreList = [
    MenuModel(
        type: MineIndexMenuType.level,
        title: "等级",
        icon: AppResource().mineLevelIcon),
    MenuModel(
        type: MineIndexMenuType.jw,
        title: "爵位",
        icon: AppResource().mineJwIcon),
    MenuModel(
        type: MineIndexMenuType.wallet,
        title: "钱包",
        icon: AppResource().mineWalletIcon)
  ];

  ///功能区域
  List<MenuModel> funcList = [
    MenuModel(
        type: MineIndexMenuType.room,
        title: "我的房间",
        icon: AppResource().mineRoomF),
    MenuModel(
        type: MineIndexMenuType.conference,
        title: "公会",
        icon: AppResource().mineConferenceF),
    MenuModel(
        type: MineIndexMenuType.shop,
        title: "商城",
        icon: AppResource().mineShopF),
    MenuModel(
        type: MineIndexMenuType.bag,
        title: "背包",
        icon: AppResource().mineBagF),
    //TODO:暂时隐藏
    /*
    MenuModel(
        type: MineIndexMenuType.task,
        title: "任务",
        icon: AppResource().mineTaskF)
     */
  ];

  ///列表区域
  List<MenuModel> itemList = [
    //TODO:先隐藏
    // MenuModel(
    //     type: MineIndexMenuType.invite,
    //     title: "邀请好友",
    //     icon: AppResource().mineInviteItem),
    //TODO:暂时隐藏
    // MenuModel(
    //     type: MineIndexMenuType.service,
    //     title: "在线客服",
    //     icon: AppResource().mineSItem),
    //TODO:暂时隐藏
    // MenuModel(
    //     type: MineIndexMenuType.children,
    //     title: "青少年模式",
    //     icon: AppResource().mineChildrenItem),
    MenuModel(
        type: MineIndexMenuType.real,
        title: "实名认证",
        icon: AppResource().mineRealItem),
    MenuModel(
        type: MineIndexMenuType.setting,
        title: "设置",
        icon: AppResource().mineSetItem),
    MenuModel(
        type: MineIndexMenuType.feed,
        title: "意见反馈",
        icon: AppResource().mineFeedItem)
  ];

  ///进入用户主页
  pushToUserDetail() {
    UserController.to
        .pushToUserDetail(UserController.to.id, UserDetailRef.other);
  }

  ///menu点击
  onClickMenu(MenuModel model) {
    switch (model.type) {
      case MineIndexMenuType.friend:
        Get.toNamed(AppRouter().otherPages.friendRoute.name);
        break;
      case MineIndexMenuType.followLive:
        Get.toNamed(AppRouter().otherPages.followLiveRoute.name);
        break;
      case MineIndexMenuType.visit:
        Get.toNamed(AppRouter().otherPages.visitRoute.name);
        break;
      case MineIndexMenuType.level:
        Get.toNamed(AppRouter().otherPages.levelRoute.name);
        break;
      case MineIndexMenuType.jw:
        ToastUtils.show("暂无开放");
        // Get.toNamed(AppRouter().otherPages.nobilityRoute.name);
        break;
      case MineIndexMenuType.wallet:
        Get.toNamed(AppRouter().walletPages.walletRoute.name);
        break;
      case MineIndexMenuType.room:
        LiveService().pushToMyLive();
        break;
      case MineIndexMenuType.conference:
        {
          showCommit();
          //0可申请 1已通过 2 申请中 3 申请被拒绝 4退会申请中 5 退会拒绝
          request(AppApi.conferenceStateUrl).then((value) {
            int state = value.data['state'];
            if (state == 0) {
              Get.toNamed(AppRouter().otherPages.conferenceRoute.name);
            } else {
              ConferenceItem item = ConferenceItem.fromJson(value.data['union']);
              Get.toNamed(
                  AppRouter().otherPages.conferenceDetailRoute.name,
                  arguments: {'state': state,'item':item});
            }
          });
        }

        break;
      case MineIndexMenuType.shop:
        Get.toNamed(AppRouter().otherPages.shopRoute.name);
        break;
      case MineIndexMenuType.bag:
        Get.toNamed(AppRouter().otherPages.bagRoute.name);
        break;
      case MineIndexMenuType.invite:
        break;
      case MineIndexMenuType.service:
        break;
      case MineIndexMenuType.children:
        Get.toNamed(AppRouter().otherPages.childrenRoute.name);
        break;
      case MineIndexMenuType.real:
        {
          if (UserController.to.userInfo.value?.isReal == 1) {
            Get.toNamed(AppRouter().otherPages.realAuthDetailRoute.name);
          } else {
            Get.toNamed(AppRouter().otherPages.realAuthIndexRoute.name);
          }
        }

        break;
      case MineIndexMenuType.setting:
        Get.toNamed(AppRouter().settingPages.setIndexRoute.name);
        break;
      case MineIndexMenuType.feed:
        Get.toNamed(AppRouter().otherPages.feedBackRoute.name);
        break;
    }
  }

  ///进入vip
  onOpenVip() {
    Get.toNamed(AppRouter().otherPages.vipRoute.name);
  }
}
