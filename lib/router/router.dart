import 'package:youyu/measurement/measurement_binding.dart';
import 'package:youyu/measurement/measurement_view.dart';
import 'package:youyu/modules/index/index_binding.dart';
import 'package:youyu/modules/index/index_view.dart';
import 'package:youyu/modules/launch/launch_binding.dart';
import 'package:youyu/modules/launch/launch_view.dart';
import 'package:youyu/modules/primary/discover/index/discover_index_binding.dart';
import 'package:youyu/modules/primary/home/home_index_binding.dart';
import 'package:youyu/modules/primary/message/index/message_index_binding.dart';
import 'package:youyu/modules/primary/mine/index/mine_index_binding.dart';
import 'package:get/get.dart';

import 'page/discover_pages.dart';
import 'page/live_pages.dart';
import 'page/login_pages.dart';
import 'page/message_pages.dart';
import 'page/other_pages.dart';
import 'page/setting_pages.dart';
import 'page/wallet_pages.dart';

class AppRouter {

  static AppRouter? _instance;

  factory AppRouter() => _instance ??= AppRouter._();

  AppRouter._();

  /// 默认路由动画
  static const defaultTransition = Transition.rightToLeft;

  /// 默认路由动画时间
  static const defaultTransitionDuration = Duration(milliseconds: 180);

  ///默认路由
  static const String initialRoutePath = "/";

  ///模块
  LoginPages loginPages = LoginPages();
  LivePages livePages = LivePages();
  SettingPages settingPages = SettingPages();
  WalletPages walletPages = WalletPages();
  DiscoverPages discoverPages = DiscoverPages();
  MessagePages messagePages = MessagePages();
  OtherPages otherPages = OtherPages();

  ///启动页面
  final GetPage initialRoute = GetPage(
    name: initialRoutePath,
    binding: LaunchBinding(),
    page: () => LaunchPage(),
    transitionDuration: Duration.zero,
    transition: Transition.noTransition,
  );

  ///主入口
  GetPage indexRoute = GetPage(
    name: '/index',
    bindings: [
      IndexBinding(),
      HomeIndexBinding(),
      DiscoverIndexBinding(),
      MessageIndexBinding(),
      MineIndexBinding()
    ],
    page: () => const IndexPage(),
    transition: Transition.fadeIn,
  );

  ///测试页面
  GetPage testRoute = GetPage(
    name: '/test',
    bindings: [
      MeasurementBinding(),
    ],
    page: () => const MeasurementPage(),
  );

  List<GetPage> routes() {
    return [
      initialRoute,
      indexRoute,
      testRoute,
      //login
      loginPages.loginIndexRoute,
      loginPages.loginAccountRoute,
      loginPages.loginQuickRoute,
      loginPages.loginInfoRoute,
      loginPages.loginFeedBackRoute,
      loginPages.pwResetRoute,
      //discover
      discoverPages.discoverDetailRoute,
      discoverPages.discoverNotifyRoute,
      discoverPages.discoverPublishRoute,
      //live
      livePages.liveIndexRoute,
      livePages.liveGiftNoticeRoute,
      livePages.liveSettingRoute,
      livePages.liveSettingMangerRoute,
      livePages.liveSettingMangerSearchRoute,
      livePages.liveSettingBlackRoute,
      //setting
      settingPages.setIndexRoute,
      settingPages.setAccountRoute,
      settingPages.setPhoneChangeRoute,
      settingPages.setPhoneChangeNextRoute,
      settingPages.setPwRoute,
      settingPages.setPrivacyRoute,
      settingPages.setBlackRoute,
      settingPages.setCheckUpdateRoute,
      settingPages.setWriteOffRoute,
      //wallet
      walletPages.walletRoute,
      walletPages.rechargeRoute,
      walletPages.payRoute,
      walletPages.applePayRoute,
      walletPages.exchangeRoute,
      walletPages.withDrawIndexRoute,
      walletPages.withDrawAccountAddRoute,
      walletPages.withDrawAccountChangeRoute,
      walletPages.recordIndexRoute,
      walletPages.backPackOrderRoute,
      //message
      messagePages.messageDetailRoute,
      messagePages.messageRemarkRoute,
      messagePages.messageSetRoute,
      messagePages.messageNotificationRoute,
      //other
      otherPages.searchRoute,
      otherPages.searchSubRoute,
      otherPages.rankIndexRoute,
      otherPages.giftDescRoute,
      otherPages.friendRoute,
      otherPages.followLiveRoute,
      otherPages.visitRoute,
      otherPages.reportRoute,
      otherPages.userDetailRoute,
      otherPages.levelRoute,
      otherPages.nobilityRoute,
      otherPages.realAuthIndexRoute,
      otherPages.realAuthDetailRoute,
      otherPages.childrenRoute,
      otherPages.childrenPwRoute,
      otherPages.feedBackRoute,
      otherPages.userImgManagerRoute,
      otherPages.userEditRoute,
      otherPages.shopRoute,
      otherPages.bagRoute,
      otherPages.vipRoute,
      otherPages.bigImageRoute,
      otherPages.webRoute,
      otherPages.userSubEditRoute,
      otherPages.conferenceRoute,
      otherPages.conferenceDetailRoute
    ];
  }
}
