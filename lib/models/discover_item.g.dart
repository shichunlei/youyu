// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discover_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiscoverItem _$DiscoverItemFromJson(Map<String, dynamic> json) => DiscoverItem(
      id: json['id'] as int? ?? 0,
      content: json['desc'] as String? ?? '',
      images: _images(json),
      audio: json['tape'] as String? ?? '',
      isLike: json['is_like'] as int? ?? 0,
      like: json['like'] as int? ?? 0,
      createTime: json['create_time'] as int? ?? 0,
      audioTime: json['tape_s'] as num? ?? 0,
      userInfo: json['user_info'] != null ? UserInfo.fromJson(json['user_info']):null,
      commentCount: json['coment_count'] as int? ?? 0,
    );

_images(json) {
  if (json['imgs'] is String) {
    return <String>[];
  } else {
    return (json['imgs'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
  }
}
