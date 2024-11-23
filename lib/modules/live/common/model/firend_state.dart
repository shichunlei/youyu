/*
 * @Author: alexalive hhyy1243047559@gmail.com
 * @Date: 2024-11-01 16:48:59
 * @LastEditors: alexalive hhyy1243047559@gmail.com
 * @LastEditTime: 2024-11-03 18:00:19
 * @FilePath: /youyu/lib/modules/live/common/model/firend_state.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
// To parse this JSON data, do
//
//     final friendState = friendStateFromJson(jsonString);

import 'dart:convert';

FriendState friendStateFromJson(String str) =>
    FriendState.fromJson(json.decode(str));

String friendStateToJson(FriendState data) => json.encode(data.toJson());

class FriendState {
  int? id;
  int? roomId;
  int? createTime;
  int? endTime = 0;
  int? relationId;
  int? status;

  FriendState({
    this.id,
    this.roomId,
    this.createTime,
    this.endTime,
    this.relationId,
    this.status,
  });

  factory FriendState.fromJson(Map<String, dynamic> json) => FriendState(
        id: json["id"],
        roomId: json["room_id"],
        createTime: json["create_time"],
        endTime: json["end_time"],
        relationId: json["relation_id"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "room_id": roomId,
        "create_time": createTime,
        "end_time": endTime,
        "relation_id": relationId,
        "status": status,
      };
}
