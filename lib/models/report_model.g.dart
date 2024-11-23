// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportModel _$ReportModelFromJson(Map<String, dynamic> json) => ReportModel(
      id: json['id'] as int? ?? 0,
      reason: json['reason'] as String? ?? "",
    );

Map<String, dynamic> _$ReportModelToJson(ReportModel instance) => <String, dynamic>{
      'id': instance.id,
      'reason': instance.reason,
    };
