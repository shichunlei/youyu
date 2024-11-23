import 'package:youyu/models/base_model.dart';
import 'package:youyu/models/gift.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class IMSlideGiftModel implements BaseModel {
  //接收人信息
  @JsonKey(name: 'to_user_info')
  final UserInfo? toUserInfo;

  @JsonKey(name: 'loss_time')
  int? lossTime;

  int? scrolling;

  //礼物模型
  @JsonKey(name: 'gift_list')
  final List<Gift>? giftList;

  final String? svge;

  IMSlideGiftModel(
      {required this.giftList,
      required this.toUserInfo,
      required this.svge,
      this.scrolling,
      this.lossTime});

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'to_user_info': toUserInfo,
        'gift_list': giftList,
        'svge': svge,
        'loss_time': lossTime,
        'scrolling': scrolling
      };

  static IMSlideGiftModel fromJson(Map<String, dynamic> json) =>
      IMSlideGiftModel(
          giftList: json['gift_list'] != null
              ? (json['gift_list'] as List<dynamic>)
                  .map((e) => Gift.fromJson(e as Map<String, dynamic>))
                  .toList()
              : null,
          scrolling: 0,
          toUserInfo: UserInfo.fromJson(json['to_user_info']),
          svge: json['svga'] as String? ?? "",
          lossTime: json['loss_time'] as int? ?? 0);
}
