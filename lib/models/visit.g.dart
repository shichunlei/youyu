// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitInfo _$VisitFromJson(Map<String, dynamic> json) => VisitInfo(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      accessId: json['access_id'] as int? ?? 0,
      num: json['num'] as int? ?? 0,
      createTime: json['create_time'] as int? ?? 0,
      userInfo: json['user_info'] != null
          ? UserInfo.fromJson(json['user_info'])
          : null,
    );

Map<String, dynamic> _$VisitToJson(VisitInfo instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'access_id': instance.accessId,
      'num': instance.num,
      'create_time': instance.createTime,
      'user_info': instance.userInfo,
    };
