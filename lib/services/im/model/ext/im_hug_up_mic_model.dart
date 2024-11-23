import 'package:youyu/models/base_model.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class IMHugUpMicMsg extends BaseModel {
  IMHugUpMicMsg({required this.position, required this.userInfo})
      : super.fromJson();

  final int position;
  @JsonKey(name: 'user_info')
  final UserInfo userInfo;

  @override
  factory IMHugUpMicMsg.fromJson(Map<String, dynamic> json) => IMHugUpMicMsg(
      position: json['position'] as int? ?? 0,
      userInfo: UserInfo.fromJson(json['user_info']));

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'position': position, 'user_info': userInfo};
  }
}
