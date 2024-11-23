// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_tab.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GiftTab _$GiftTabFromJson(Map<String, dynamic> json) => GiftTab(
      giftList: (json['gift_list'] as List<dynamic>)
          .map((e) => Gift.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] as int,
      name: json['name'] as String,
    );

Map<String, dynamic> _$GiftTabToJson(GiftTab instance) => <String, dynamic>{
      'gift_list': instance.giftList,
      'id': instance.id,
      'name': instance.name,
    };
