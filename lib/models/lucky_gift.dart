import 'package:youyu/models/gift.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

part 'lucky_gift.g.dart';

@JsonSerializable()
class LuckyGift implements BaseModel {
  @JsonKey(name: 'user_info')
  final UserInfo userInfo;

  @JsonKey(name: 'gift')
  final Gift gift;

  LuckyGift({
    required this.userInfo,
    required this.gift,
  });

  @override
  factory LuckyGift.fromJson(Map<String, dynamic> json) =>
      _$LuckyGiftFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$LuckyGiftToJson(this);
}
