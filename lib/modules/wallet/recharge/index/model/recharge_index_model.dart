// To parse this JSON data, do
//
//     final rechargeItem = rechargeItemFromJson(jsonString);

import 'dart:convert';

RechargeItem rechargeItemFromJson(String str) =>
    RechargeItem.fromJson(json.decode(str));

String rechargeItemToJson(RechargeItem data) => json.encode(data.toJson());

class RechargeItem {
  int? money;
  int? coins;
  int? give;

  RechargeItem({
    this.money,
    this.coins,
    this.give,
  });

  factory RechargeItem.fromJson(Map<String, dynamic> json) => RechargeItem(
        money: json["money"],
        coins: json["coins"],
        give: json["give"],
      );

  Map<String, dynamic> toJson() => {
        "money": money,
        "coins": coins,
        "give": give,
      };
}
