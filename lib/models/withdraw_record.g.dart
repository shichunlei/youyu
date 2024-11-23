// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdraw_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WithDrawRecord _$WithDrawRecordFromJson(Map<String, dynamic> json) =>
    WithDrawRecord(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      type: json['type'] as String? ?? '',
      state: json['state'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      account: json['account'] as String? ?? '',
      money: json['money'] as String? ?? '',
      createTime: json['create_time'] as String? ?? '',
    );

Map<String, dynamic> _$WithDrawRecordToJson(WithDrawRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'type': instance.type,
      'state': instance.state,
      'name': instance.name,
      'account': instance.account,
      'money': instance.money,
      'createTime': instance.createTime,
    };
