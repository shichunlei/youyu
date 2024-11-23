import 'package:youyu/models/base_model.dart';
import 'package:youyu/models/my_getuserinfo.dart';

class IMForbiddenMsg extends BaseModel {
  IMForbiddenMsg({required this.userInfo}) : super.fromJson();

  final UserInfo userInfo;

  @override
  factory IMForbiddenMsg.fromJson(Map<String, dynamic> json) =>
      IMForbiddenMsg(userInfo: UserInfo.fromJson(json['userInfo']));

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userInfo': userInfo,
    };
  }
}
