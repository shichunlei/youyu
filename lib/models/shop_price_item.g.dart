// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_price_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopPriceItem _$ShopPriceItemFromJson(Map<String, dynamic> json) =>
    ShopPriceItem(
        id: json['id'] as int? ?? 0,
        goodsId: json['goods_id'] as int? ?? 0,
        day: json['day'] as int? ?? 0,
        price: json['price'] as int? ?? 0,
        createTime: json['create_time'] as int? ?? 0);

Map<String, dynamic> _$ShopPriceItemToJson(ShopPriceItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'goods_id': instance.goodsId,
      'day': instance.day,
      'price': instance.price,
      'create_time': instance.createTime,
    };
