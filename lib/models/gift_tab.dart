import 'package:youyu/models/gift.dart';
import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';
part 'gift_tab.g.dart';

@JsonSerializable()
class GiftTab implements BaseModel {
  @JsonKey(name: 'gift_list')
  final List<Gift> giftList;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'id')
  final int id;

  GiftTab({
    required this.giftList,
    required this.name,
    required this.id,
  });

  @override
  factory GiftTab.fromJson(Map<String, dynamic> json) =>
      _$GiftTabFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$GiftTabToJson(this);
}
