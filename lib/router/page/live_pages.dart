import 'package:youyu/modules/live/index/live_index_binding.dart';
import 'package:youyu/modules/live/index/live_index_view.dart';
import 'package:youyu/modules/live/sub/blacklist/live_setting_black_binding.dart';
import 'package:youyu/modules/live/sub/blacklist/live_setting_black_view.dart';
import 'package:youyu/modules/live/sub/giftnotice/live_sub_gift_notice_binding.dart';
import 'package:youyu/modules/live/sub/giftnotice/live_sub_gift_notice_view.dart';
import 'package:youyu/modules/live/sub/manager/live_setting_manager_binding.dart';
import 'package:youyu/modules/live/sub/manager/live_setting_manager_view.dart';
import 'package:youyu/modules/live/sub/manager/search/live_setting_manager_search_binding.dart';
import 'package:youyu/modules/live/sub/manager/search/live_setting_manager_search_view.dart';
import 'package:youyu/modules/live/sub/setting/live_setting_binding.dart';
import 'package:youyu/modules/live/sub/setting/live_setting_view.dart';
import 'package:get/get.dart';

class LivePages {
  ///直播间
  GetPage liveIndexRoute = GetPage(
    name: '/live',
    bindings: [
      LiveIndexBinding(),
    ],
    page: () => LiveIndexPage(),
  );

  ///礼物公告详情
  GetPage liveGiftNoticeRoute = GetPage(
    name: '/live_gift_notice',
    bindings: [
      LiveSubGiftNoticeBinding(),
    ],
    page: () => LiveSubGiftNoticePage(),
  );

  ///直播间设置页面
  GetPage liveSettingRoute = GetPage(
    name: '/live_setting',
    bindings: [
      LiveSettingBinding(),
    ],
    page: () => LiveSettingPage(),
  );

  ///直播间设置页面 - 管理员
  GetPage liveSettingMangerRoute = GetPage(
    name: '/live_setting_manager',
    bindings: [
      LiveSettingManagerBinding(),
    ],
    page: () => LiveSettingManagerPage(),
  );

  ///直播间设置页面 - 管理员
  GetPage liveSettingMangerSearchRoute = GetPage(
    name: '/live_setting_manager_search',
    bindings: [
      LiveSettingManagerSearchBinding(),
    ],
    page: () => LiveSettingManagerSearchPage(),
  );

  ///直播间设置页面 - 黑名单
  GetPage liveSettingBlackRoute = GetPage(
    name: '/live_setting_black',
    bindings: [
      LiveSettingBlackBinding(),
    ],
    page: () => LiveSettingBlackPage(),
  );
}
