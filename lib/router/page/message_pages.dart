import 'package:youyu/modules/primary/message/message/message/message_detail_binding.dart';
import 'package:youyu/modules/primary/message/message/message/message_detail_view.dart';
import 'package:youyu/modules/primary/message/notification/message_notification_binding.dart';
import 'package:youyu/modules/primary/message/notification/message_notification_view.dart';
import 'package:youyu/modules/primary/message/remark/message_remark_binding.dart';
import 'package:youyu/modules/primary/message/remark/message_remark_view.dart';
import 'package:youyu/modules/primary/message/setting/message_setting_binding.dart';
import 'package:youyu/modules/primary/message/setting/message_setting_view.dart';
import 'package:get/get.dart';

class MessagePages {
  ///聊天页面
  GetPage messageDetailRoute = GetPage(
    name: '/messageDetail',
    bindings: [
      MessageDetailBinding(),
    ],
    page: () => const MessageDetailPage(),
  );

  ///聊天备注
  GetPage messageRemarkRoute = GetPage(
    name: '/messageRemark',
    bindings: [
      MessageRemarkBinding(),
    ],
    page: () => MessageRemarkPage(),
  );

  ///聊天设置
  GetPage messageSetRoute = GetPage(
    name: '/messageSet',
    bindings: [
      MessageSettingBinding(),
    ],
    page: () => const MessageSettingPage(),
  );

  ///聊天通知
  GetPage messageNotificationRoute = GetPage(
    name: '/messageNotification',
    bindings: [
      MessageNotificationBinding(),
    ],
    page: () => MessageNotificationPage(),
  );
}
