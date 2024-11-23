part of 'banner_model.dart';

BannerModel _$BannerModelFromJson(Map<String, dynamic> json) => BannerModel(
      id: json['id'] as int? ?? 0,
      img: json['img'] as String? ?? "",
      sort: json['sort'] as int? ?? 0,
      val: json['val'] as String? ?? "",
      type: json['type'] as int? ?? 0,
    );

Map<String, dynamic> _$BannerModelToJson(BannerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'img': instance.img,
      'sort': instance.sort,
      'val': instance.val,
      'type': instance.type,
    };
