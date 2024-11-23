// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backpack_gift.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BackpackGift _$BackpackGiftFromJson(Map<String, dynamic> json) => BackpackGift(
      chat: json['chat'] as int,
      count: json['count'] as int,
      id: json['id'] as int,
      image: json['image'] as String,
      lotteryPrice: json['lottery_price'] as int,
      name: json['name'] as String,
      playSvg: json['play_svg'] as int,
      svg: json['svg'] as String,
      scrolling: json['scrolling'] as int,
      show: json['show'] as int,
      unitPrice: json['unit_price'] as int,
    );

Map<String, dynamic> _$BackpackGiftToJson(BackpackGift instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'unit_price': instance.unitPrice,
      'image': instance.image,
      'show': instance.show,
      'play_svg': instance.playSvg,
      'svg': instance.svg,
      'scrolling': instance.scrolling,
      'chat': instance.chat,
      'lottery_price': instance.lotteryPrice,
      'count': instance.count,
    };
