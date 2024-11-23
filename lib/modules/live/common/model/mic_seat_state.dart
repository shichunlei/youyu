import 'package:youyu/models/my_getuserinfo.dart';

class MicSeatState {
  late int t;

  MicSeatState({
    required this.state,
    required this.mute,
    required this.position,
    required this.charm,
    required this.heart,
    required this.wishGiftId,
    this.user,
  }) {
    t = DateTime.now().millisecondsSinceEpoch;
  }

  /// 麦位状态
  /// 0：空位
  /// 1：上麦
  /// 2：锁麦
  final int state;

  /// 是否禁麦
  final int mute;

  /// 麦位序号
  /// 0为主持位
  final int position;

  final UserInfo? user;

  ///魅力值
  final int charm;

  ///心动值
  final int heart;

  ///心愿礼物
  final int wishGiftId;
}
