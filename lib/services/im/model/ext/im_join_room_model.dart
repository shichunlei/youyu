import 'package:youyu/models/base_model.dart';
import 'package:youyu/models/my_getuserinfo.dart';

class IMJoinRoomMsg extends BaseModel {
  IMJoinRoomMsg({required this.userInfo}) : super.fromJson();

  final UserInfo userInfo;

  @override
  factory IMJoinRoomMsg.fromJson(Map<String, dynamic> json) =>
      IMJoinRoomMsg(userInfo: UserInfo.fromJson(json['userInfo']));

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userInfo': userInfo,
    };
  }
}
