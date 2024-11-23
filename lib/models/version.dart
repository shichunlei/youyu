import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'version.g.dart';

@JsonSerializable()
class Version implements BaseModel {
  final int id;
  final String? num;
  final String? content;
  final String? url;

  @JsonKey(name: 'is_force')
  final int? isForce;

  Version({
    required this.id,
    required this.num,
    required this.content,
    required this.url,
    this.isForce,
  });

  @override
  factory Version.fromJson(Map<String, dynamic> json) => _$VersionFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$VersionToJson(this);
}
