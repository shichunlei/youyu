import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'dress.g.dart';

@JsonSerializable()
class DressInfo implements BaseModel {
  final int? id;

  final int? type;
  final String? name;
  final String? img;
  final String? res;

  DressInfo({
    this.id,
    this.type,
    this.name,
    this.img,
    this.res,
  });

  @override
  factory DressInfo.fromJson(Map<String, dynamic> json) => _$DressInfoFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$DressInfoToJson(this);
}
