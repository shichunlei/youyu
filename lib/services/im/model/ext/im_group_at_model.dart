import 'package:youyu/models/base_model.dart';
import 'package:youyu/models/my_getuserinfo.dart';

class IMGroupAtTextMsg extends BaseModel {
  IMGroupAtTextMsg({
    required this.text,
    required this.atUsers,
  }) : super.fromJson();

  final String text;
  final List<UserInfo> atUsers;

  @override
  factory IMGroupAtTextMsg.fromJson(Map<String, dynamic> json) =>
      IMGroupAtTextMsg(
        text: json['text'] as String? ?? "",
        atUsers: (json['atUsers'] as List<dynamic>)
            .map((e) => UserInfo.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'text': text, 'atUsers': atUsers};
  }
}
