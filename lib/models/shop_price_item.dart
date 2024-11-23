import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';
part 'shop_price_item.g.dart';

@JsonSerializable()
class ShopPriceItem implements BaseModel {

  final int? id;

  @JsonKey(name: 'goods_id')
  final int? goodsId;

  final int? day;

  final int? price;

  @JsonKey(name: 'create_time')
  final int? createTime;

  ShopPriceItem({
    this.id,
    this.goodsId,
    this.day,
    this.price,
    this.createTime,
  });

  @override
  factory ShopPriceItem.fromJson(Map<String, dynamic> json) =>
      _$ShopPriceItemFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$ShopPriceItemToJson(this);
}
