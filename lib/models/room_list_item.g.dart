// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomListItem _$RoomListItemFromJson(Map<String, dynamic> json) => RoomListItem(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      fancyNumber: json['fancy_number'] as int? ?? 0,
      lock: json['lock'] as int? ?? 0,
      onlineUserCount: json['online_user_count'] as int? ?? 0,
      onlineUserList: _onListUserList(json),
      groupId: _groupId(json['group_id']),
      bigAvatar: json['big_avatar'] as String? ?? '',
      heat: json['heat'] as int? ?? 0,
      typeId: json['type_id'] as int? ?? 0,
      typeName: json['type_name'] as String? ?? '',
      headAvatar: json['head_avatar'] as String? ?? '',
      headGender: json['head_gender'] as int? ?? 0,
      roomCreateNickname: json['head_name'] as String? ?? '',
    );

String _groupId(data) {
  if (data != null) {
    if (data is num) {
      return (data as int? ?? 0).toString();
    } else {
      return data as String? ?? '';
    }
  }
  return '';
}

_onListUserList(Map<String, dynamic> json) {
  var list = json['online_user_list'];
  if (list != null) {
    return (list as List<dynamic>)
        .map((e) => RoomListItemOnlineUser.fromJson(e as Map<String, dynamic>))
        .toList();
  } else {
    List<RoomListItemOnlineUser> list = [];
    return list;
  }
}

Map<String, dynamic> _$RoomListItemToJson(RoomListItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'fancy_number': instance.fancyNumber,
      'lock': instance.lock,
      'online_user_List': instance.onlineUserList,
      'group_id': instance.groupId,
      'big_avatar': instance.bigAvatar,
      'heat': instance.heat,
      'type_id': instance.typeId,
      'type_name': instance.typeName,
      'head_avatar': instance.headAvatar,
      'head_gender': instance.headGender,
      'head_name': instance.roomCreateNickname,
      'online_user_count':instance.onlineUserCount
    };
