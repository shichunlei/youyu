import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'sync_room_seat.g.dart';

@JsonSerializable()
class SyncRoomSeat implements BaseModel {
  /// 麦位信息 0:空位 1:有人 2:锁麦
  final int state;

  /// 是否静音
  final int mute;

  /// 麦位序号 0-8
  final int position;

  /// 魅力值
  final int charm;

  ///心动值
  final int heart;

  //心愿礼物
  final int wishGiftId;

  /// 用户ID 如果为-1,则该位置没有人
  @JsonKey(name: 'user_id')
  final int userId;

  SyncRoomSeat({
    required this.state,
    required this.mute,
    required this.position,
    required this.charm,
    required this.userId,
    required this.heart,
    required this.wishGiftId,
  });

  @override
  factory SyncRoomSeat.fromJson(Map<String, dynamic> json) =>
      _$SyncRoomSeatFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$SyncRoomSeatToJson(this);
}
