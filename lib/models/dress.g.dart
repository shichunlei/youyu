// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DressInfo _$DressInfoFromJson(Map<String, dynamic> json) => DressInfo(
      id: json['id'] as int? ?? 0,
      type: json['type'] as int? ?? 0,
      name: json['name'] as String? ?? "",
      img: json['img'] as String? ?? "",
      res: json['res'] as String? ?? "",
    );

Map<String, dynamic> _$DressInfoToJson(DressInfo instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'img': instance.img,
      'res': instance.res,
    };
