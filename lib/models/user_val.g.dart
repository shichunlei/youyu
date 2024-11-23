// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_val.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserVal _$UserValFromJson(Map<String, dynamic> json) => UserVal(
    charm: json['charm'] as int? ?? 0,
    wealth: json['wealth'] as int? ?? 0,
    exp: json['exp'] as int? ?? 0,
    titleId: _titleId(json),
    titleImg: json['title_img'] as String? ?? '',
    titleName: json['title_name'] as String? ?? '',
    levelId: _levelId(json),
    levelName: json['level_name'] as String? ?? '',
    levelImg: json['level_img'] as String? ?? '',
    levelColour: json['level_colour'] as String? ?? '');

int _titleId(Map<String, dynamic> json) {
  if (json['title_id'] is String) {
    String id = json['title_id'] as String;
    if (id.isNotEmpty) {
      return int.parse(id);
    } else {
      return 0;
    }
  } else {
    return json['title_id'] as int? ?? 0;
  }
}

int _levelId(Map<String, dynamic> json) {
  if (json['level_id'] is String) {
    String id = json['level_id'] as String;
    if (id.isNotEmpty) {
      return int.parse(id);
    } else {
      return 0;
    }
  } else {
    return json['level_id'] as int? ?? 0;
  }
}

Map<String, dynamic> _$UserValToJson(UserVal instance) => <String, dynamic>{
      'exp': instance.exp,
      'wealth': instance.wealth,
      'charm': instance.charm,
      'title_id': instance.titleId,
      'title_img': instance.titleImg,
      'title_name': instance.titleName,
      'level_id': instance.levelId,
      'level_name': instance.levelName,
      'level_img': instance.levelImg,
      'level_colour': instance.levelColour
    };
