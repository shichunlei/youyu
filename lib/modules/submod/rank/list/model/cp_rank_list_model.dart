// To parse this JSON data, do
//
//     final cpRankModel = cpRankModelFromJson(jsonString);

import 'dart:convert';

import 'package:youyu/models/my_getuserinfo.dart';

CpRankModel cpRankModelFromJson(String str) =>
    CpRankModel.fromJson(json.decode(str));

String cpRankModelToJson(CpRankModel data) => json.encode(data.toJson());

class CpRankModel {
  int? userId;
  int? cpUserId;
  String? num;
  UserInfo? userInfo;
  UserInfo? cpUserInfo;

  CpRankModel({
    this.userId,
    this.cpUserId,
    this.num,
    this.userInfo,
    this.cpUserInfo,
  });

  factory CpRankModel.fromJson(Map<String, dynamic> json) => CpRankModel(
        userId: json["user_id"],
        cpUserId: json["cp_user_id"],
        num: json["num"],
        userInfo: json["user_info"] == null
            ? null
            : UserInfo.fromJson(json["user_info"]),
        cpUserInfo: json["cp_user_info"] == null
            ? null
            : UserInfo.fromJson(json["cp_user_info"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "cp_user_id": cpUserId,
        "num": num,
        "user_info": userInfo?.toJson(),
        "cp_user_info": cpUserInfo?.toJson(),
      };
}
