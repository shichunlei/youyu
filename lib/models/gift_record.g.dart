// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GiftRecord _$GiftRecordFromJson(Map<String, dynamic> json) => GiftRecord(
    userName: json['user_name'] as String,
    toUserName: json['to_user_name'] as String,
    giftName: json['gift_name'] as String?,
    num: json['num'] as int?,
    image: json['image'] as String? ?? "",
    createTime: json['create_time'] as int? ?? 0);

Map<String, dynamic> _$GiftRecordToJson(GiftRecord instance) =>
    <String, dynamic>{
      'user_name': instance.userName,
      'to_user_name': instance.toUserName,
      'gift_name': instance.giftName,
      'num': instance.num,
      'image': instance.image,
      'create_time': instance.createTime
    };
