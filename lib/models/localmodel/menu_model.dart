import 'package:flutter/material.dart';

///公用按钮模型
class MenuModel {
  ///事件构造
  static createEventModel(dynamic type) {
    return MenuModel(type: type, title: "", icon: "");
  }

  MenuModel(
      {required this.title, required this.icon, this.subTitle, this.type});

  final String title;
  final String? subTitle;
  final String icon;

  dynamic type;
}

enum PopMenuModelType {
  copy,
  del,
}

class PopMenuModel {
  PopMenuModel(this.type, {required this.title, required this.icon});

  final String title;
  final IconData icon;
  final PopMenuModelType type;
}
