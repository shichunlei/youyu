import 'package:youyu/models/base_model.dart';

class IMLiveTextMsg extends BaseModel {
  IMLiveTextMsg({required this.text}) : super.fromJson();

  final String text;

  @override
  factory IMLiveTextMsg.fromJson(Map<String, dynamic> json) =>
      IMLiveTextMsg(text: json['text'] as String? ?? "");

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'text': text,
    };
  }
}
