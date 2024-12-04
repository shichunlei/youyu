// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopItem _$ShopItemFromJson(Map<String, dynamic> json) => ShopItem(
      id: json['id'] as int? ?? 0,
      type: json['type'] as int? ?? 0,
      status: json['status'] as int? ?? 0,
      state: json['state'] as int? ?? 0,
      image: json['img'] as String? ?? '',
      title: json['name'] as String? ?? '',
      price: json['price'] != null
          ? (json['price'] as List<dynamic>)
              .map((e) => ShopPriceItem.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      res: json['res'] as String? ?? '',
      isSet: json['is_set'] as int? ?? 0,
      fancyNumber: json['fancy_number'] as String? ?? '',
      endTime: json['end_time'] as int? ?? 0
    );

Map<String, dynamic> _$ShopItemToJson(ShopItem instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'state': instance.state,
      'status': instance.status,
      'name': instance.title,
      'img': instance.image,
      'res': instance.res,
      'price': instance.price,
      'end_time':instance.endTime,
      'fancy_number': instance.fancyNumber,
    };
