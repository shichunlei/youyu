import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';
import 'gift.dart';

part 'gift_game.g.dart';

@JsonSerializable()
class GiftGame implements BaseModel {
  @JsonKey(name: 'gift_id')
  final int giftId;
  final String name;
  @JsonKey(name: 'unit_price')
  final int unitPrice;
  final String desc;
  @JsonKey(name: 'show_list')
  List<Gift>? showList;

  GiftGame(
      {required this.giftId,
      required this.name,
      required this.unitPrice,
      required this.desc,
      this.showList});

  @override
  factory GiftGame.fromJson(Map<String, dynamic> json) =>
      _$GiftGameFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GiftGameToJson(this);
}
