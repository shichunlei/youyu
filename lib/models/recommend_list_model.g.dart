// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommend_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendListModel _$RecommendListModelFromJson(Map<String, dynamic> json) =>
    RecommendListModel(
      banner: (json['banner'] as List<dynamic>)
          .map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      list: (json['list'] as List<dynamic>)
          .map((e) => RoomListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RecommendListModelToJson(RecommendListModel instance) =>
    <String, dynamic>{
      'banner': instance.banner,
      'hot_data': instance.list,
    };
