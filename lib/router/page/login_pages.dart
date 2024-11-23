import 'package:youyu/modules/login/account/login_account_binding.dart';
import 'package:youyu/modules/login/account/login_account_view.dart';
import 'package:youyu/modules/login/back/login_feed_back_binding.dart';
import 'package:youyu/modules/login/back/login_feed_back_view.dart';
import 'package:youyu/modules/login/index/login_index_binding.dart';
import 'package:youyu/modules/login/index/login_index_view.dart';
import 'package:youyu/modules/login/info/login_info_binding.dart';
import 'package:youyu/modules/login/info/login_info_view.dart';
import 'package:youyu/modules/login/quick/login_quick_binding.dart';
import 'package:youyu/modules/login/quick/login_quick_view.dart';
import 'package:youyu/modules/login/reset/pw_reset_binding.dart';
import 'package:youyu/modules/login/reset/pw_reset_view.dart';
import 'package:get/get.dart';

class LoginPages {

  ///登录入口
  GetPage loginIndexRoute = GetPage(
    name: '/loginIndex',
    bindings: [
      LoginIndexBinding(),
    ],
    page: () => LoginIndexPage(),
  );

  ///账号密码登录
  GetPage loginAccountRoute = GetPage(
    name: '/loginAccount',
    bindings: [
      LoginAccountBinding(),
    ],
    page: () => LoginAccountPage(),
  );

  ///快捷登录
  GetPage loginQuickRoute = GetPage(
    name: '/loginQuick',
    bindings: [
      LoginQuickBinding(),
    ],
    page: () => LoginQuickPage(),
  );

  ///重置密码
  GetPage pwResetRoute = GetPage(
    name: '/pwReset',
    bindings: [
      PwResetBinding(),
    ],
    page: () => PwResetPage(),
  );

  ///登录反馈
  GetPage loginFeedBackRoute = GetPage(
    name: '/loginFeedBack',
    bindings: [
      LoginFeedBackBinding(),
    ],
    page: () => LoginFeedBackPage(),
  );

  ///登录设置信息
  GetPage loginInfoRoute = GetPage(
    name: '/loginInfo',
    bindings: [
      LoginInfoBinding(),
    ],
    page: () => LoginInfoPage(),
  );


}