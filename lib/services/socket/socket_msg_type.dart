/*
 * @Author: alexalive hhyy1243047559@gmail.com
 * @Date: 2024-10-21 22:41:28
 * @LastEditors: alexalive hhyy1243047559@gmail.com
 * @LastEditTime: 2024-11-04 14:49:20
 * @FilePath: /youyu/lib/services/socket/socket_msg_type.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
///ws 消息类型
class SocketMessageType {
  /// 心跳
  static const String ping = 'ping';

  /// 进入直播间
  static const String joinRoom = 'joinroom';

  /// 退出直播间
  static const String outRoom = 'outroom';

  /// 麦位操作
  static const String actionWheat = 'wheat';

  /// 麦位禁麦/解麦操作
  static const String position = 'position';

  /// 飘屏
  static const String floatingScreen = 'floating_screen';

  /// 飘屏
  static const String boxGiftList = 'box_gift_list';

  /// 邂逅开启
  static const String friendsOpen = 'friends_open';

  /// 邂逅关闭
  static const String friendsEnd = 'friends_end';

  ///邂逅时间
  static const String friendsTime = 'friends_increase';

  ///世界消息
  static const String worldMsg = 'world_message_update';

  ///直播间热度
  static const String liveHeat = 'update_room_heat';
}
