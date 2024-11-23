import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/models/room_detail_info.dart';
import 'package:youyu/services/live/live_service.dart';
import 'abs/live_notification.dart';

///直播间设置通知
class LiveSettingNotify extends LiveNotificationDispatch {
  ///直播间设置
  roomSettingNotify(
      LiveSettingType settingType,RoomDetailInfo roomDetailInfo) {
    notification?.roomSettingNotify(settingType,roomDetailInfo);
  }

  ///管理员设置
  ///0:删除 1:增加
  roomSetManagerNotify({required int status, required UserInfo userInfo}) {
    notification?.roomSetManagerNotify(status: status, userInfo: userInfo);
  }

  ///解除禁言
  roomRemoveForbidden(UserInfo userInfo) {
    notification?.roomRemoveForbidden(userInfo);
  }

  @override
  onClose() {}
}
