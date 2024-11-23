import 'package:youyu/models/base_model.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class IMScreenSpeakMsg extends BaseModel {
  IMScreenSpeakMsg({required this.isSpeak}) : super.fromJson();

  @JsonKey(name: "is_speak")
  final int? isSpeak;

  @override
  factory IMScreenSpeakMsg.fromJson(Map<String, dynamic> json) =>
      IMScreenSpeakMsg(isSpeak: json['is_speak'] as int? ?? 0);

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'is_speak': isSpeak,
    };
  }
}
