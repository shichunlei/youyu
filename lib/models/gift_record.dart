import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'gift_record.g.dart';

@JsonSerializable()
class GiftRecord implements BaseModel {
  @JsonKey(name: 'user_name')
  final String? userName;

  @JsonKey(name: 'to_user_name')
  final String? toUserName;

  @JsonKey(name: 'gift_name')
  final String? giftName;

  @JsonKey(name: 'create_time')
  final int? createTime;

  final int? num;

  final String? image;

  GiftRecord(
      {required this.userName,
      required this.toUserName,
      required this.giftName,
      required this.num,
      required this.createTime,
      required this.image});

  @override
  factory GiftRecord.fromJson(Map<String, dynamic> json) =>
      _$GiftRecordFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$GiftRecordToJson(this);
}
