// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Gift _$GiftFromJson(Map<String, dynamic> json) => Gift(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String,
      image: json['image'] as String?,
      img: json['img'] as String?,
      unitPrice: json['unit_price'] as int,
      playSvg: json['play_svg'] as int?,
      svg: json['svg'] as String?,
      chat: json['chat'] as int?,
      scrolling: json['scrolling'] as int?,
      count: json['count'] as int?,
      childList: json['child_list'] != null
          ? (json['child_list'] as List<dynamic>)
              .map((e) => Gift.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );

Map<String, dynamic> _$GiftToJson(Gift instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'img':instance.img,
      'unit_price': instance.unitPrice,
      'play_svg': instance.playSvg,
      'svg': instance.svg,
      'scrolling': instance.scrolling,
      'chat': instance.chat,
      'count': instance.count,
      'child_list': instance.childList
    };
