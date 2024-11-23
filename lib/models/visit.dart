import 'package:youyu/models/my_getuserinfo.dart';
import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'visit.g.dart';

@JsonSerializable()
class VisitInfo implements BaseModel {
  final int? id;

  @JsonKey(name: 'user_id')
  final int? userId;

  @JsonKey(name: 'access_id')
  final int? accessId;

  final int? num;

  @JsonKey(name: 'create_time')
  final int? createTime;

  @JsonKey(name: 'user_info')
  final UserInfo? userInfo;

  VisitInfo({
    required this.id,
    required this.userId,
    required this.accessId,
    required this.num,
    this.createTime,
    this.userInfo,
  });

  @override
  factory VisitInfo.fromJson(Map<String, dynamic> json) => _$VisitFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$VisitToJson(this);
}
