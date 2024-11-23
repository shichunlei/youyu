import 'package:youyu/models/room_background.dart';
import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'room_detail_info.g.dart';

@JsonSerializable()
class RoomDetailInfo implements BaseModel {
  final int? id;

  @JsonKey(name: 'user_id')
  final int? userId;

  /// 头像
  final String? avatar;

  /// 名称
  final String? name;

  /// 房间靓号
  @JsonKey(name: 'fancy_number')
  final int? fancyNumber;

  ///分类id
  @JsonKey(name: 'type_id')
  final int? typeId;


  /// 类型名称
  @JsonKey(name: 'type_name')
  final String? typeName;

  /// 是否有锁
  final int? lock;

  /// IM
  @JsonKey(name: 'group_id')
  final String? groupId;

  /// 当前状态 0关播 1:开播
  final int? status;

  ///是否关注直播间
  @JsonKey(name: 'is_follow_room')
  final int? isFollowRoom;

  /// 公告
  final String? announcement;

  /// 欢迎语
  final String? welcome;

  ///热度
  final int? heat;

  /// 背景图片
  final RoomBackGround? background;

  /// 是否为我的房间
  @JsonKey(name: 'this_room')
  final int? thisRoom;

  /// 我是否为管理员
  @JsonKey(name: 'is_manage')
  final int? isManage;

  /// 我是否被拉黑
  @JsonKey(name: 'is_black')
  final int? isBlack;

  /// 我是否被禁言
  @JsonKey(name: 'is_muted')
  final int? isMute;

  ///是否可以发言（1 可以 0 不可以）
  @JsonKey(name: 'is_speak')
  final int? isSpeak;


  RoomDetailInfo({
    this.isSpeak,
    required this.id,
    required this.userId,
    required this.announcement,
    required this.avatar,
    required this.background,
    required this.fancyNumber,
    required this.groupId,
    required this.isBlack,
    required this.isManage,
    required this.isMute,
    required this.lock,
    required this.name,
    required this.status,
    required this.thisRoom,
    required this.typeName,
    required this.welcome,
    required this.typeId,
    required this.heat,
    required this.isFollowRoom
  });

  @override
  factory RoomDetailInfo.fromJson(Map<String, dynamic> json) =>
      _$RoomDetailInfoFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$RoomDetailInfoToJson(this);
}
