// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diamond_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiamondRecord _$DiamondRecordFromJson(Map<String, dynamic> json) => DiamondRecord(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      type: json['type'] as int? ?? 0,
      number: json['number'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
      dataId: json['data_id'] as int? ?? 0,
      createTime: json['create_time'] as int? ?? 0,
    );

Map<String, dynamic> _$DiamondRecordToJson(DiamondRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'type': instance.type,
      'number': instance.number,
      'desc': instance.desc,
      'data_id': instance.dataId,
      'createTime': instance.createTime,
    };
