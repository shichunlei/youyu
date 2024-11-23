// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lucky_gift.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LuckyGift _$LuckyGiftFromJson(Map<String, dynamic> json) => LuckyGift(
    gift: Gift.fromJson(json['gift']),
    userInfo: UserInfo.fromJson(json['user_info']));

Map<String, dynamic> _$LuckyGiftToJson(LuckyGift instance) => <String, dynamic>{
      'user_info': instance.userInfo,
      'gift': instance.gift,
    };
