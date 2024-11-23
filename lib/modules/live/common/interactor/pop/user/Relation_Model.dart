// To parse this JSON data, do
//
//     final relationModel = relationModelFromJson(jsonString);

import 'dart:convert';

RelationModel relationModelFromJson(String str) =>
    RelationModel.fromJson(json.decode(str));

String relationModelToJson(RelationModel data) => json.encode(data.toJson());

class RelationModel {
  CpInfo? cpInfo;
  List<RelationList>? relationList;

  RelationModel({
    this.cpInfo,
    this.relationList,
  });

  factory RelationModel.fromJson(Map<String, dynamic> json) => RelationModel(
        cpInfo:
            json["cp_info"] == null ? null : CpInfo.fromJson(json["cp_info"]),
        relationList: json["relation_list"] == null
            ? []
            : List<RelationList>.from(
                json["relation_list"]!.map((x) => RelationList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cp_info": cpInfo?.toJson(),
        "relation_list": relationList == null
            ? []
            : List<dynamic>.from(relationList!.map((x) => x.toJson())),
      };
}

class CpInfo {
  int? userId;
  String? nickname;
  String? avatar;
  String? val;

  CpInfo({
    this.userId,
    this.nickname,
    this.avatar,
    this.val,
  });

  factory CpInfo.fromJson(Map<String, dynamic> json) => CpInfo(
        userId: json["user_id"],
        nickname: json["nickname"],
        avatar: json["avatar"],
        val: json["val"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "nickname": nickname,
        "avatar": avatar,
        "val": val,
      };
}

class RelationList {
  int? userId;
  String? nickname;
  String? avatar;
  String? textImg;
  String? bgImg;
  int? endTime;

  RelationList({
    this.userId,
    this.nickname,
    this.avatar,
    this.textImg,
    this.bgImg,
    this.endTime,
  });

  factory RelationList.fromJson(Map<String, dynamic> json) => RelationList(
        userId: json["user_id"],
        nickname: json["nickname"],
        avatar: json["avatar"],
        textImg: json["text_img"],
        bgImg: json["bg_img"],
        endTime: json["end_time"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "nickname": nickname,
        "avatar": avatar,
        "text_img": textImg,
        "bg_img": bgImg,
        "end_time": endTime,
      };
}
