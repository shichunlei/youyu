// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Version _$VersionFromJson(Map<String, dynamic> json) => Version(
    id: json['id'] as int,
    num: json['num'] as String? ?? '',
    content: json['content'] as String? ?? '',
    url: json['url'] as String? ?? '',
    isForce: json['is_force'] as int? ?? 0);

Map<String, dynamic> _$VersionToJson(Version instance) => <String, dynamic>{
      'id': instance.id,
      'num': instance.num,
      'content': instance.content,
      'url': instance.url,
      'is_force': instance.isForce,
    };
