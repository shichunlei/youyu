import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'user_level.g.dart';

@JsonSerializable()
class UserLevel implements BaseModel {
  String img;
  final int exp;

  //本地组装数据
  int? minExp;
  int? maxExp;
  int? minLevel;
  int? maxLevel;

  UserLevel({
    required this.img,
    required this.exp,
    this.minExp,
    this.maxExp,
    this.minLevel,
    this.maxLevel,
  });

  @override
  factory UserLevel.fromJson(Map<String, dynamic> json) =>
      _$UserLevelFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$UserLevelToJson(this);
}
