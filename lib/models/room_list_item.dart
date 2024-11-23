import 'package:youyu/models/room_list_item_online_user.dart';
import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'room_list_item.g.dart';

@JsonSerializable()
class RoomListItem implements BaseModel {
  //直播间id
  final int id;

  //靓号
  @JsonKey(name: 'fancy_number')
  final int? fancyNumber;

  //昵称
  final String name;

  //im的群组id
  @JsonKey(name: 'group_id')
  final String groupId;

  @JsonKey(name: 'head_avatar')
  String? headAvatar;

  @JsonKey(name: 'big_avatar')
  //大头像（背景图）
  String? bigAvatar;

  //用户性别 0未知 1男 2女
  @JsonKey(name: 'head_gender')
  int? headGender;

  //是否加锁
  final int? lock;

  //热度
  int? heat;

  //标签id
  @JsonKey(name: 'type_id')
  int? typeId;

  //标签名称
  @JsonKey(name: 'type_name')
  String? typeName;

  @JsonKey(name: 'online_user_List')
  List<RoomListItemOnlineUser> onlineUserList;

  @JsonKey(name: 'online_user_count')
  int? onlineUserCount;

  //主播昵称
  @JsonKey(name: 'head_name')
  String? roomCreateNickname;

  RoomListItem({
    required this.id,
    required this.name,
    required this.fancyNumber,
    required this.lock,
    required this.onlineUserList,
    required this.groupId,
    this.bigAvatar,
    this.heat,
    this.typeId,
    this.typeName,
    this.headAvatar,
    this.headGender,
    this.roomCreateNickname,
    this.onlineUserCount
  });

  @override
  factory RoomListItem.fromJson(Map<String, dynamic> json) =>
      _$RoomListItemFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$RoomListItemToJson(this);
}
