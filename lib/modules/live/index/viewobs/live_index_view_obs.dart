/*
 * @Author: alexalive hhyy1243047559@gmail.com
 * @Date: 2024-10-30 12:02:28
 * @LastEditors: alexalive hhyy1243047559@gmail.com
 * @LastEditTime: 2024-11-06 17:46:06
 * @FilePath: /youyu/lib/modules/live/index/viewobs/live_index_view_obs.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/models/room_background.dart';
import 'package:get/get.dart';

///试图数据
class LiveIndexViewObs {
  ///麦位的上边距
  double get seatMarginTop => 17.h;

  ///整体麦位View的高度  //7+7+7+95*3 =307
  double get seatAllHeight => 307.h;

  ///进入漂屏的top
  double get joinSlideTop =>
      seatAllHeight +
      ScreenUtils.navbarHeight +
      ScreenUtils.statusBarHeight +
      48.h +
      38.h;

  double get giftNormalSlideTop =>
      seatAllHeight +
      ScreenUtils.navbarHeight +
      ScreenUtils.statusBarHeight +
      48.h +
      38.h;

  var giftSlideTop = 0.0.obs;

  ///名称
  var name = ''.obs;

  ///类型
  var roomType = ''.obs;

  ///背景
  Rx<RoomBackGround?> roomBackInfo = Rx(null);

  ///公告
  var notice = ''.obs;

  //热度
  var liveHot = '0'.obs;

  //是否关注直播间
  var isFocusLive = 0.obs;

  //是否加锁
  var lock = 0.obs;

  /// 前三用户
  RxList<UserInfo> top3UserList = <UserInfo>[].obs;

  /// 在线用户
  RxList<UserInfo> onlineUserList = <UserInfo>[].obs;


  onClose() {}
}
