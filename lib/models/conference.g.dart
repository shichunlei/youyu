// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConferenceItem _$ConferenceItemFromJson(Map<String, dynamic> json) =>
    ConferenceItem(
        id: json['id'] as int? ?? 0,
        name: json['name'] as String? ?? '',
        fancyNumber: json['fancy_number'] as int? ?? 0,
        logo: json['logo'] as String? ?? "",
        userNum: json['user_num'] as int? ?? 0);

Map<String, dynamic> _$ConferenceItemToJson(ConferenceItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'fancy_number': instance.fancyNumber,
      'logo': instance.logo,
      'user_num': instance.userNum
    };
