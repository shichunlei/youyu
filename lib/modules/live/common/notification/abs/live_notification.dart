import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/models/room_detail_info.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:get/get.dart';

import '../live_gift_notify.dart';
import '../live_join_notify.dart';
import '../live_screen_notify.dart';
import '../live_setting_notify.dart';
import '../live_tip_slide_notify.dart';
import '../live_top_slide_notify.dart';
import '../live_vip_slide_notify.dart';

abstract class LiveNotification {
  ///通知分发
  //公屏
  late LiveScreenNotify screenNotify = LiveScreenNotify();

  //进入房间漂屏
  late LiveJoinNotify joinSlideNotify = LiveJoinNotify();

  //礼物漂屏和礼物特效
  late LiveGiftNotify giftSlideNotify = LiveGiftNotify();

  //顶部漂屏
  late LiveTopSlideNotify topSlideNotify = LiveTopSlideNotify();

  //提示漂屏
  late LiveTipSlideNotify tipSlideNotify = LiveTipSlideNotify();

  //vip漂屏 (暂时不用)
  late LiveVipSlideNotify vipSlideNotify = LiveVipSlideNotify();

  //设置通知
  late LiveSettingNotify settingNotify = LiveSettingNotify();

  roomSettingNotify(LiveSettingType settingType, RoomDetailInfo roomDetailInfo);

  roomSetManagerNotify({required int status, required UserInfo userInfo});

  roomRemoveForbidden(UserInfo userInfo);
}

abstract class LiveNotificationDispatch {
  late Rx<RoomDetailInfo?> roomInfoObs;
  LiveNotification? notification;
  //开始
  onStart(
      {LiveNotification? notification,
      required Rx<RoomDetailInfo?> roomInfoObs}) {
    this.notification = notification;
    this.roomInfoObs = roomInfoObs;
  }

  //释放
  onClose();
}
