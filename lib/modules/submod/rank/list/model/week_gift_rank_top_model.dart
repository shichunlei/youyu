// To parse this JSON data, do
//
//     final weekGiftTopModel = weekGiftTopModelFromJson(jsonString);

import 'dart:convert';

WeekGift weekGiftTopModelFromJson(String str) =>
    WeekGift.fromJson(json.decode(str));

String weekGiftTopModelToJson(WeekGift data) => json.encode(data.toJson());

class WeekGift {
  String? image;
  int? id;
  String? name;

  WeekGift({
    this.image,
    this.id,
    this.name,
  });

  factory WeekGift.fromJson(Map<String, dynamic> json) => WeekGift(
        image: json["image"],
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "id": id,
        "name": name,
      };
}
