import 'package:youyu/models/base_model.dart';
import 'package:youyu/models/my_getuserinfo.dart';

class IMKickOutMsg extends BaseModel {
  IMKickOutMsg({required this.userInfo}) : super.fromJson();

  final UserInfo userInfo;

  @override
  factory IMKickOutMsg.fromJson(Map<String, dynamic> json) =>
      IMKickOutMsg(userInfo: UserInfo.fromJson(json['userInfo']));

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userInfo': userInfo,
    };
  }
}
