// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoinRecord _$CoinRecordFromJson(Map<String, dynamic> json) => CoinRecord(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      type: json['type'] as int? ?? 0,
      number: json['number'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
      dataId: json['data_id'] as int? ?? 0,
      createTime: json['create_time'] as int? ?? 0,
    );

Map<String, dynamic> _$CoinRecordToJson(CoinRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'type': instance.type,
      'number': instance.number,
      'desc': instance.desc,
      'data_id': instance.dataId,
      'createTime': instance.createTime,
    };
