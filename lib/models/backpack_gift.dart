import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'backpack_gift.g.dart';
@JsonSerializable()
class BackpackGift implements BaseModel {
  final int id;
  final String name;

  @JsonKey(name: 'unit_price')
  final int unitPrice;

  final String image;
  final int show;

  @JsonKey(name: 'play_svg')
  final int playSvg;

  final String svg;

  final int scrolling;
  final int chat;

  @JsonKey(name: 'lottery_price')
  final int lotteryPrice;

  final int count;

  BackpackGift({
    required this.chat,
    required this.count,
    required this.id,
    required this.image,
    required this.lotteryPrice,
    required this.name,
    required this.playSvg,
    required this.svg,
    required this.scrolling,
    required this.show,
    required this.unitPrice,
  });

  @override
  factory BackpackGift.fromJson(Map<String, dynamic> json) =>
      _$BackpackGiftFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$BackpackGiftToJson(this);
}
