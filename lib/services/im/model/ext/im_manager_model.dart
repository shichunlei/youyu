import 'package:youyu/models/base_model.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class IMSyncManagerMsg implements BaseModel {
  /// 操作状态 0:删除 1:增加
  final int status;

  final UserInfo user;

  IMSyncManagerMsg({
    required this.status,
    required this.user,
  });

  @override
  factory IMSyncManagerMsg.fromJson(Map<String, dynamic> json) =>
      IMSyncManagerMsg(
        status: json['status'] as int,
        user: UserInfo.fromJson(json['user'] as Map<String, dynamic>),
      );

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'status': status,
        'user': user,
      };
}
