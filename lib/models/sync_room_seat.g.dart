// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_room_seat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncRoomSeat _$SyncRoomSeatFromJson(Map<String, dynamic> json) => SyncRoomSeat(
      state: (json['state'] as num).toInt(),
      mute: (json['mute'] as num).toInt(),
      position: (json['position'] as num).toInt(),
      charm: (json['charm'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      heart: (json['heart'] as num).toInt(),
      wishGiftId: (json['wish_gift_id'] as num).toInt(),
    );

Map<String, dynamic> _$SyncRoomSeatToJson(SyncRoomSeat instance) =>
    <String, dynamic>{
      'state': instance.state,
      'mute': instance.mute,
      'position': instance.position,
      'charm': instance.charm,
      'heart': instance.heart,
      'wish_gift_id': instance.wishGiftId,
      'user_id': instance.userId,
    };
