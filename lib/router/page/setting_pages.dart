import 'package:youyu/modules/setting/account/account_binding.dart';
import 'package:youyu/modules/setting/account/account_view.dart';
import 'package:youyu/modules/setting/account/sub/change/phone_change_binding.dart';
import 'package:youyu/modules/setting/account/sub/change/phone_change_view.dart';
import 'package:youyu/modules/setting/account/sub/changenext/phone_change_next_binding.dart';
import 'package:youyu/modules/setting/account/sub/changenext/phone_change_next_view.dart';
import 'package:youyu/modules/setting/account/sub/setpw/set_pw_binding.dart';
import 'package:youyu/modules/setting/account/sub/setpw/set_pw_view.dart';
import 'package:youyu/modules/setting/black/setting_black_binding.dart';
import 'package:youyu/modules/setting/black/setting_black_view.dart';
import 'package:youyu/modules/setting/checkupdate/setting_check_update_binding.dart';
import 'package:youyu/modules/setting/checkupdate/setting_check_update_view.dart';
import 'package:youyu/modules/setting/index/setting_index_binding.dart';
import 'package:youyu/modules/setting/index/setting_index_view.dart';
import 'package:youyu/modules/setting/privacy/setting_privacy_binding.dart';
import 'package:youyu/modules/setting/privacy/setting_privacy_view.dart';
import 'package:youyu/modules/setting/writeoff/setting_write_off_binding.dart';
import 'package:youyu/modules/setting/writeoff/setting_write_off_view.dart';
import 'package:get/get.dart';

class SettingPages {
  ///设置
  GetPage setIndexRoute = GetPage(
    name: '/setting',
    bindings: [
      SettingIndexBinding(),
    ],
    page: () => SettingIndexPage(),
  );

  ///账号安全
  GetPage setAccountRoute = GetPage(
    name: '/set_account',
    bindings: [
      AccountBinding(),
    ],
    page: () => AccountPage(),
  );

  ///更换手机号
  GetPage setPhoneChangeRoute = GetPage(
    name: '/set_phone_change',
    bindings: [
      PhoneChangeBinding(),
    ],
    page: () => const PhoneChangePage(),
  );

  ///更换手机号下一步
  GetPage setPhoneChangeNextRoute = GetPage(
    name: '/st_phoneChange_next',
    bindings: [
      PhoneChangeNextBinding(),
    ],
    page: () => PhoneChangeNextPage(),
  );

  ///设置密码||修改密码
  GetPage setPwRoute = GetPage(
    name: '/set_pw',
    bindings: [
      SetPwBinding(),
    ],
    page: () => SetPwPage(),
  );

  ///隐私设置
  GetPage setPrivacyRoute = GetPage(
    name: '/set_privacy',
    bindings: [
      SettingPrivacyBinding(),
    ],
    page: () => SettingPrivacyPage(),
  );

  ///设置黑名单
  GetPage setBlackRoute = GetPage(
    name: '/set_black',
    bindings: [
      SettingBlackBinding(),
    ],
    page: () => SettingBlackPage(),
  );

  ///版本更新
  GetPage setCheckUpdateRoute = GetPage(
    name: '/set_check_update',
    bindings: [
      SettingCheckUpdateBinding(),
    ],
    page: () => SettingCheckUpdatePage(),
  );

  ///注销登录
  GetPage setWriteOffRoute = GetPage(
    name: '/set_write_off',
    bindings: [
      SettingWriteOffBinding(),
    ],
    page: () => SettingWriteOffPage(),
  );
}
