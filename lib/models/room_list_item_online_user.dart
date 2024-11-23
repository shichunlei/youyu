import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'room_list_item_online_user.g.dart';

@JsonSerializable()
class RoomListItemOnlineUser implements BaseModel {
  final int id;
  final String? avatar;

  RoomListItemOnlineUser({
    required this.id,
    required this.avatar,
  });

  @override
  factory RoomListItemOnlineUser.fromJson(Map<String, dynamic> json) =>
      _$RoomListItemOnlineUserFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$RoomListItemOnlineUserToJson(this);
}
