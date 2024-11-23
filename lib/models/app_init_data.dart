import 'package:youyu/models/gift_tab.dart';
import 'package:youyu/models/user_level.dart';
import 'package:youyu/models/user_nobility.dart';
import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'app_init_data.g.dart';

@JsonSerializable()
class AppInitData implements BaseModel {
  @JsonKey(name: 'app_min_version')
  final String appMinVersion;

  @JsonKey(name: 'app_max_version')
  final String appMaxVersion;

  @JsonKey(name: 'user_default_avatar')
  final String userDefaultAvatar;

  @JsonKey(name: 'diamond_ratio')
  final String diamondRatio;

  @JsonKey(name: 'gift_list')
  final List<GiftTab> giftList;

  @JsonKey(name: 'user_level_list')
  final List<List<UserLevel>> userLevelList;

  @JsonKey(name: 'user_title_list')
  final List<UserNobilityModel> userTitleList;

  @JsonKey(name: 'tencent_user_prefix')
  final String tencentUserPrefix;

  @JsonKey(name: 'user_agreement')
  final String? userAgreement;

  @JsonKey(name: 'privacy_agreement')
  final String? privacyAgreement;

  @JsonKey(name: 'user_recharge')
  final String? userRecharge;

  @JsonKey(name: 'gift_describe')
  final String? gift_describe;


  AppInitData({
    required this.appMaxVersion,
    required this.appMinVersion,
    required this.diamondRatio,
    required this.giftList,
    required this.userDefaultAvatar,
    required this.userLevelList,
    required this.tencentUserPrefix,
    required this.userTitleList,
    this.userRecharge,
    this.gift_describe,
    this.userAgreement,
    this.privacyAgreement,
  });

  @override
  factory AppInitData.fromJson(Map<String, dynamic> json) =>
      _$AppInitDataFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$AppInitDataToJson(this);
}
