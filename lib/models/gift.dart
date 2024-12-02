import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'gift.g.dart';

@JsonSerializable()
class Gift implements BaseModel {
   int? id;
  final String name;
  String? image;
  String? img;

  @JsonKey(name: 'unit_price')
  final int unitPrice;

  //是否播放svg
  @JsonKey(name: 'play_svg')
  int? playSvg;

  final String? svg;

  final int? scrolling;

  final int? chat;

  int? count;

  @JsonKey(name: 'child_list')
  List<Gift>? childList;

  Gift(
      {required this.id,
      required this.name,
      required this.unitPrice,
      this.image,
      this.img,
      this.playSvg,
      this.svg,
      this.chat,
      this.scrolling,
      this.count,
      this.childList});

  @override
  factory Gift.fromJson(Map<String, dynamic> json) => _$GiftFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$GiftToJson(this);
}
