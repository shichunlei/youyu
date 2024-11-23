// To parse this JSON data, do
//
//     final worldMsg = worldMsgFromJson(jsonString);

import 'dart:convert';

WorldMsg worldMsgFromJson(String str) => WorldMsg.fromJson(json.decode(str));

String worldMsgToJson(WorldMsg data) => json.encode(data.toJson());

class WorldMsg {
  String? message;
  int? price;
  WorldMsgUserInfo? userInfo;

  WorldMsg({
    this.message,
    this.price,
    this.userInfo,
  });

  factory WorldMsg.fromJson(Map<String, dynamic> json) => WorldMsg(
        message: json["message"],
        price: json["price"],
        userInfo: json["user_info"] == null
            ? null
            : WorldMsgUserInfo.fromJson(json["user_info"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "price": price,
        "user_info": userInfo?.toJson(),
      };
}

class WorldMsgUserInfo {
  int? id;
  String? avatar;
  String? nickname;

  WorldMsgUserInfo({
    this.id,
    this.avatar,
    this.nickname,
  });

  factory WorldMsgUserInfo.fromJson(Map<String, dynamic> json) =>
      WorldMsgUserInfo(
        id: json["id"],
        avatar: json["avatar"],
        nickname: json["nickname"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "avatar": avatar,
        "nickname": nickname,
      };
}
