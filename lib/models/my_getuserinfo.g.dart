// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_getuserinfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
    id: json['id'] as int? ?? 0,
    fancyNumber: json['fancy_number'] is String
        ? int.parse(json['fancy_number'] as String? ?? "0")
        : json['fancy_number'] as int? ?? 0,
    proportion: json['proportion'] is String
        ? double.parse(json['proportion'] as String? ?? "0").toInt()
        : json['proportion'] as int? ?? 0,
    mobile: json['mobile'] as String? ?? '',
    nickname: json['nickname'] as String? ?? '',
    avatar: _avatar(json['avatar']),
    coins: json['coins'] as num? ?? 0,
    diamonds: json['diamonds'] as num? ?? 0,
    gender: json['gender'] as int? ?? 0,
    isReal: json['is_real'] as int? ?? 0,
    isFancyNumber: json['is_fancy_number'] as int? ?? 0,
    signature: json['signature'] as String? ?? '',
    birthTime: json['birth_time'] as int? ?? 0,
    onlineStatus: json['online_status'] as int? ?? 0,
    onlineRoom: json['online_room'] as int? ?? 0,
    status: json['status'] as int? ?? 1,
    region:
        (json['region'] as List<dynamic>?)?.map((e) => e as String).toList() ??
            const [],
    interest: json['interest'] as String? ?? '',
    accessCount: json['access_count'] as int? ?? 0,
    focusCount: json['focus_count'] as int? ?? 0,
    focusMeCount: json['focus_me_count'] as int? ?? 0,
    friendCount: json['friend_count'] as int? ?? 0,
    imGroupId: json['group_id'] as String? ?? '',
    thisRoom: json['this_room'] as int? ?? 0,
    userVal: json['user_val'] == null
        ? null
        : UserVal.fromJson(json['user_val'] as Map<String, dynamic>),
    imUserSig: json['im_user_sig'] as String? ?? '',
    isFriend: json['is_friend'] as int? ?? 0,
    meIsFocusUser: json['me_is_focus_user'] as int? ?? 0,
    userIsFocusMe: json['user_is_focus_me'] as int? ?? 0,
    focusNewCount: json['access_unread_count'] as int? ?? 0,
    focusRoomCount: json['focus_room_count'] as int? ?? 0,
    showGame: json['show_game'] as int? ?? 0,
    thisRoomInfo: json['this_room_info'] == null
        ? null
        : RoomListItem.fromJson(json['this_room_info'] as Map<String, dynamic>),
    is_vip: json['is_vip'] as int? ?? 0,
    is_svip: json['is_svip'] as int? ?? 0,
    is_play: json['is_play'] as int? ?? 0,
    isBlock: json['is_block'] as int? ?? 0,
    isManage: json['is_manage'] as int? ?? 0,
    numCoin: json['num'] as String? ?? '',
    isCoverBlock: json['is_cover_block'] as int? ?? 0,
    isMuted: json['is_muted'] as int? ?? 0,
    isPass: json['is_pass'] as int? ?? 0,
    unionId: json['union_id'] is int
        ? (json['union_id'] as int? ?? 0).toString()
        : (json['union_id'] as String? ?? ''),
    unionName: json['union_name'] as String? ?? '',
    dress: _dressList(json));

List<DressInfo>? _dressList(json) {
  if (json['dress'] != null) {
    return (json['dress'] as List<dynamic>?)
            ?.map((e) => e != null ? DressInfo.fromJson(e) : DressInfo())
            .toList() ??
        const [];
  }
  return null;
}

String? _avatar(var data) {
  if (data != null) {
    if (data is int) {
      return (data).toString();
    } else {
      return data as String? ?? '';
    }
  } else {
    return null;
  }
}

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'access_count': instance.accessCount,
      'avatar': instance.avatar,
      'birth_time': instance.birthTime,
      'coins': instance.coins,
      'diamonds': instance.diamonds,
      'fancy_number': instance.fancyNumber,
      'focus_count': instance.focusCount,
      'focus_me_count': instance.focusMeCount,
      'friend_count': instance.friendCount,
      'gender': instance.gender,
      'group_id': instance.imGroupId,
      'id': instance.id,
      'interest': instance.interest,
      'mobile': instance.mobile,
      'nickname': instance.nickname,
      'online_room': instance.onlineRoom,
      'online_status': instance.onlineStatus,
      'region': instance.region,
      'signature': instance.signature,
      'status': instance.status,
      'this_room': instance.thisRoom,
      'user_val': instance.userVal,
      'im_user_sig': instance.imUserSig,
      'user_is_focus_me': instance.userIsFocusMe,
      'me_is_focus_user': instance.meIsFocusUser,
      'is_friend': instance.isFriend,
      'this_room_info': instance.thisRoomInfo,
      'show_game': instance.showGame,
      'is_fancy_number': instance.isFancyNumber,
      'access_unread_count': instance.focusNewCount,
      'focus_room_count': instance.focusRoomCount,
      'is_svip': instance.is_svip,
      'is_vip': instance.is_vip,
      'is_play': instance.is_play,
      'is_real': instance.isReal,
      'is_block': instance.isBlock,
      'is_manage': instance.isManage,
      'num': instance.numCoin,
      'is_cover_block': instance.isCoverBlock,
      'is_muted': instance.isMuted,
      'is_pass': instance.isPass,
      'union_id': instance.unionId,
      'union_name': instance.unionName,
      'dress': instance.dress,
      'proportion': instance.proportion
    };
