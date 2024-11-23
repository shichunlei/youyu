/*
 * @Author: alexalive hhyy1243047559@gmail.com
 * @Date: 2024-11-03 01:31:52
 * @LastEditors: alexalive hhyy1243047559@gmail.com
 * @LastEditTime: 2024-11-03 01:31:54
 * @FilePath: /youyu/lib/modules/live/common/interactor/pop/relation/live_relation_model.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
// To parse this JSON data, do
//
//     final relationType = relationTypeFromJson(jsonString);

import 'dart:convert';

RelationType relationTypeFromJson(String str) =>
    RelationType.fromJson(json.decode(str));

String relationTypeToJson(RelationType data) => json.encode(data.toJson());

class RelationType {
  int? id;
  String? name;

  RelationType({
    this.id,
    this.name,
  });

  factory RelationType.fromJson(Map<String, dynamic> json) => RelationType(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
