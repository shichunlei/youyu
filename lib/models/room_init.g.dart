// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_init.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomInit _$RoomInitFromJson(Map<String, dynamic> json) => RoomInit(
      isManage: json['is_manage'] as int,
      isBlack: json['is_black'] as int,
      isMute: json['is_mute'] as int,
      lock: json['lock'] as int,
    );

Map<String, dynamic> _$RoomInitToJson(RoomInit instance) => <String, dynamic>{
      'is_manage': instance.isManage,
      'is_black': instance.isBlack,
      'is_mute': instance.isMute,
      'lock': instance.lock,
    };
