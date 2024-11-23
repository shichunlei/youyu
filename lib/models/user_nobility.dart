//爵位
import 'package:flutter/material.dart';

class UserNobilityModel {
  UserNobilityModel(
      {required this.id,
      required this.name,
      required this.img,
      this.bgGradient,
      this.exp});

  final int id;
  final String name;
  final String img;
  LinearGradient? bgGradient;

  //经验
  int? exp;

  static UserNobilityModel fromJson(Map<String, dynamic> json) {
    return UserNobilityModel(
      id: json['id'],
      name: json['name'],
      img: json['img'] as String,
      bgGradient: null,
      exp: json['exp'] as int? ?? 0,
    );
  }
}
