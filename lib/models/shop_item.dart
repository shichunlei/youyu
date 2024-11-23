import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';
import 'shop_price_item.dart';

part 'shop_item.g.dart';

@JsonSerializable()
class ShopItem implements BaseModel {
  final int? id;
  final int? type;
  final int? status;
  //1 可以购买 2 已经有了可以再次购买续时长 3 买了永久的了 不可以再买了
  int? state;

  @JsonKey(name: 'is_set')
  int? isSet;

  @JsonKey(name: 'img')
  final String? image;

  @JsonKey(name: 'name')
  final String? title;

  final String? res;

  final List<ShopPriceItem>? price;

  @JsonKey(name: 'fancy_number')
  final String? fancyNumber;

  ShopItem({
    this.id,
    this.type,
    this.image,
    this.title,
    this.res,
    this.status,
    this.state,
    this.price,
    this.isSet,
    this.fancyNumber,
  });

  @override
  factory ShopItem.fromJson(Map<String, dynamic> json) =>
      _$ShopItemFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$ShopItemToJson(this);
}
