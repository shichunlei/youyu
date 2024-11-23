import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'report_model.g.dart';

@JsonSerializable()
class ReportModel implements BaseModel {

  final int id;
  String? reason;

  ReportModel({
    required this.id,
    this.reason,
  });

  @override
  factory ReportModel.fromJson(Map<String, dynamic> json) =>
      _$ReportModelFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$ReportModelToJson(this);
}
