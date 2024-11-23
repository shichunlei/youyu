import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'user_val.g.dart';

@JsonSerializable()
class UserVal implements BaseModel {
  //经验
  final int exp;

  //财富
  final int wealth;

  //魅力
  final int charm;

  @JsonKey(name: 'title_id')
  final int? titleId;

  @JsonKey(name: 'title_img')
  final String? titleImg;

  @JsonKey(name: 'title_name')
  final String? titleName;

  @JsonKey(name: 'level_id')
  final int? levelId;

  @JsonKey(name: 'level_name')
  final String? levelName;

  @JsonKey(name: 'level_img')
  final String? levelImg;

  @JsonKey(name: 'level_colour')
  final String? levelColour;


  UserVal({
    this.charm = 0,
    this.wealth = 0,
    this.exp = 0,
    this.titleId,
    this.titleImg,
    this.titleName,
    this.levelId,
    this.levelName,
    this.levelImg,
    this.levelColour,
  });

  @override
  factory UserVal.fromJson(Map<String, dynamic> json) =>
      _$UserValFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$UserValToJson(this);
}
