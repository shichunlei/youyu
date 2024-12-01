// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GiftGame _$GiftGameFromJson(Map<String, dynamic> json) => GiftGame(
      giftId: json['gift_id'] as int? ?? 0,
      name: json['name'] as String,
      desc: json['desc'] as String,
      unitPrice: json['unit_price'] as int,
      showList: json['show_list'] != null
          ? (json['show_list'] as List<dynamic>)
              .map((e) => Gift.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );

Map<String, dynamic> _$GiftGameToJson(GiftGame instance) => <String, dynamic>{
      'gift_id': instance.giftId,
      'name': instance.name,
      'desc': instance.desc,
      'unit_price': instance.unitPrice,
      'show_list': instance.showList
    };
