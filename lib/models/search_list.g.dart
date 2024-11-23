// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchList _$SearchListFromJson(Map<String, dynamic> json) => SearchList(
      userList: (json['user_list'] as List<dynamic>)
          .map((e) => UserInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      roomList: (json['room_list'] as List<dynamic>)
          .map((e) => RoomListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchListToJson(SearchList instance) =>
    <String, dynamic>{
      'user_list': instance.userList,
      'room_list': instance.roomList,
    };
