// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_socket_server_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebSocketServerMessage _$WebSocketServerMessageFromJson(
        Map<String, dynamic> json) =>
    WebSocketServerMessage(
      code: json['code'] as int? ??0,
      msg: json['msg'] as String,
      type: json['type'] as String,
      data: json['data'],
    );

Map<String, dynamic> _$WebSocketServerMessageToJson(
        WebSocketServerMessage instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'type': instance.type,
      'data': instance.data,
    };
