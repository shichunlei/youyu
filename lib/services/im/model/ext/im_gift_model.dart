import 'package:youyu/models/base_model.dart';
import 'package:youyu/models/gift.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class IMGiftModel implements BaseModel {
  //接收人信息
  final UserInfo? receiver;

  //礼物模型
  final Gift? gift;

  IMGiftModel({required this.gift, required this.receiver});

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'receiver': receiver,
        'gift': gift,
      };

  static IMGiftModel fromJson(Map<String, dynamic> json) => IMGiftModel(
      gift: Gift.fromJson(json['gift']),
      receiver: UserInfo.fromJson(json['receiver']));
}
