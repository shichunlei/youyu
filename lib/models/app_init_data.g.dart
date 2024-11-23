// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_init_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppInitData _$AppInitDataFromJson(Map<String, dynamic> json) => AppInitData(
      userRecharge: json['user_recharge'] as String? ?? "",
      appMaxVersion: json['app_max_version'] as String,
      appMinVersion: json['app_min_version'] as String,
      diamondRatio: json['diamond_ratio'] as String,
      giftList: (json['gift_list'] as List<dynamic>)
          .map((e) => GiftTab.fromJson(e as Map<String, dynamic>))
          .toList(),
      userDefaultAvatar: json['user_default_avatar'] as String,
      userLevelList: (json['user_level_list'] as List<dynamic>)
          .map((list) => (list as List<dynamic>)
              .map((item) => UserLevel.fromJson(item as Map<String, dynamic>))
              .toList())
          .toList(),
      userTitleList: (json['user_title_list'] as List<dynamic>)
          .map((e) => UserNobilityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      tencentUserPrefix: json['tencent_user_prefix'] as String,
      userAgreement: json['user_agreement'] as String? ?? "",
      privacyAgreement: json['privacy_agreement'] as String? ?? "",
      gift_describe: json['gift_describe'] as String? ?? "",
    );

Map<String, dynamic> _$AppInitDataToJson(AppInitData instance) =>
    <String, dynamic>{
      'app_min_version': instance.appMinVersion,
      'app_max_version': instance.appMaxVersion,
      'user_default_avatar': instance.userDefaultAvatar,
      'diamond_ratio': instance.diamondRatio,
      'gift_list': instance.giftList,
      'user_level_list': instance.userLevelList,
      'tencent_user_prefix': instance.tencentUserPrefix,
      'user_agreement': instance.userAgreement,
      'privacy_agreement': instance.privacyAgreement,
      'user_title_list': instance.userTitleList,
      'gift_describe': instance.gift_describe,
      'user_recharge': instance.userRecharge
    };
