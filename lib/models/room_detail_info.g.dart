// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_detail_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomDetailInfo _$RoomDetailInfoFromJson(Map<String, dynamic> json) =>
    RoomDetailInfo(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      announcement: json['announcement'] as String? ?? "",
      avatar: json['avatar'] as String? ?? "",
      background: json['background'] != null
          ? RoomBackGround.fromJson(json['background'])
          : null,
      fancyNumber: json['fancy_number'] as int? ?? 0,
      groupId: json['group_id'] as String? ?? "",
      isBlack: json['is_black'] as int? ?? 0,
      isManage: json['is_manage'] as int? ?? 0,
      isMute: json['is_muted'] as int? ?? 0,
      lock: json['lock'] as int? ?? 0,
      name: json['name'] as String,
      status: json['status'] as int? ?? 0,
      heat: json['heat'] as int? ?? 0,
      thisRoom: json['this_room'] as int? ?? 0,
      typeId: json['type_id'] as int? ?? 0,
      typeName: json['type_name'] as String? ?? "",
      welcome: json['welcome'] as String? ?? "",
      isFollowRoom: json['is_follow_room'] as int? ?? 0,
      isSpeak: json['is_speak'] as int? ?? 0,
    );

Map<String, dynamic> _$RoomDetailInfoToJson(RoomDetailInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'avatar': instance.avatar,
      'name': instance.name,
      'fancy_number': instance.fancyNumber,
      'type_id': instance.typeId,
      'type_name': instance.typeName,
      'lock': instance.lock,
      'group_id': instance.groupId,
      'status': instance.status,
      'announcement': instance.announcement,
      'welcome': instance.welcome,
      'background': instance.background,
      'this_room': instance.thisRoom,
      'is_manage': instance.isManage,
      'is_black': instance.isBlack,
      'is_mute': instance.isMute,
      'heat': instance.heat,
      'is_follow_room': instance.isFollowRoom,
      'is_speak': instance.isSpeak
    };
