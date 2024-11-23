import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';

part 'web_socket_server_message.g.dart';

@JsonSerializable()
class WebSocketServerMessage implements BaseModel {
  final int code;

  final String msg;

  final String type;

  final dynamic data;

  WebSocketServerMessage({
    required this.code,
    required this.msg,
    required this.type,
    required this.data,
  });

  @override
  factory WebSocketServerMessage.fromJson(Map<String, dynamic> json) =>
      _$WebSocketServerMessageFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  @override
  Map<String, dynamic> toJson() => _$WebSocketServerMessageToJson(this);
}
