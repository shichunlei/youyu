import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'conference.g.dart';

@JsonSerializable()
class ConferenceItem implements BaseModel {
  final int? id;

  @JsonKey(name: 'fancy_number')
  final int? fancyNumber;

  final String? name;

  String? logo;

  @JsonKey(name: 'user_num')
  int? userNum;

  ConferenceItem({
    required this.id,
    required this.name,
    required this.fancyNumber,
    this.logo,
    this.userNum,
  });

  @override
  factory ConferenceItem.fromJson(Map<String, dynamic> json) =>
      _$ConferenceItemFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$ConferenceItemToJson(this);
}
