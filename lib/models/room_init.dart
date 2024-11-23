import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'room_init.g.dart';

@JsonSerializable()
class RoomInit implements BaseModel {
  @JsonKey(name: 'is_manage')
  final int isManage;

  @JsonKey(name: 'is_black')
  final int isBlack;

  @JsonKey(name: 'is_mute')
  final int isMute;

  final int lock;

  RoomInit({
    required this.isManage,
    required this.isBlack,
    required this.isMute,
    required this.lock,
  });

  @override
  factory RoomInit.fromJson(Map<String, dynamic> json) =>
      _$RoomInitFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$RoomInitToJson(this);
}
