import 'package:youyu/modules/primary/discover/detail/discover_detail_binding.dart';
import 'package:youyu/modules/primary/discover/detail/discover_detail_view.dart';
import 'package:youyu/modules/primary/discover/notification/discover_notification_binding.dart';
import 'package:youyu/modules/primary/discover/notification/discover_notification_view.dart';
import 'package:youyu/modules/primary/discover/publish/discover_publish_binding.dart';
import 'package:youyu/modules/primary/discover/publish/discover_publish_view.dart';
import 'package:get/get.dart';

class DiscoverPages {
  ///详情
  GetPage discoverDetailRoute = GetPage(
    name: '/discover_detail',
    bindings: [
      DiscoverDetailBinding(),
    ],
    page: () => const DiscoverDetailPage(),
  );

  ///通知消息
  GetPage discoverNotifyRoute = GetPage(
    name: '/discover_notify',
    bindings: [
      DiscoverNotificationBinding(),
    ],
    page: () => DiscoverNotificationPage(),
  );

  ///发布
  GetPage discoverPublishRoute = GetPage(
    name: '/discover_publish',
    bindings: [
      DiscoverPublishBinding(),
    ],
    page: () => DiscoverPublishPage(),
  );
}
