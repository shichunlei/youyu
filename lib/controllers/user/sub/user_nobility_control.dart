import 'package:youyu/controllers/app_controller.dart';
import 'package:youyu/controllers/user/sub/abs/user_sub_control.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/user_nobility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///爵位管理
class UserNobilityControl extends UserSubControl {
  //爵位列表
  var nobilityList = <UserNobilityModel>[].obs;
  final List<LinearGradient> _bgList = [
    _nobilityGradient(const Color(0xFF5A38B0), const Color(0xFF361C51)),
    _nobilityGradient(const Color(0xFF3ABDEF), const Color(0xFF1238A1)),
    _nobilityGradient(const Color(0xFF845BC2), const Color(0xFF563D91)),
    _nobilityGradient(const Color(0xFFEE95B9), const Color(0xFFA50B2E)),
    _nobilityGradient(const Color(0xFF80E9FD), const Color(0xFF006DCB)),
    _nobilityGradient(const Color(0xFFD9440D), const Color(0xFFFF9E94)),
    _nobilityGradient(const Color(0xFFB657D4), const Color(0xFF4B09A1)),
  ];

  @override
  onUpdateUserInfo() {
    List<UserNobilityModel> list =
        AppController.to.appInitData.value?.userTitleList ?? [];
    for (int i = 0; i < list.length; i++) {
      UserNobilityModel model = list[i];
      model.bgGradient = _bgList[i];
    }
    nobilityList.value = list;
  }

  ///自己对应爵位
  UserNobilityModel? myCurNobilityModel() {
    if ((UserController.to.userInfo.value?.userVal?.titleId ?? 0) > 0) {
      return UserNobilityModel(
          id: UserController.to.userInfo.value?.userVal?.titleId ?? 0,
          name: UserController.to.userInfo.value?.userVal?.titleName ?? "",
          img: UserController.to.userInfo.value?.userVal?.titleImg ?? "",
          exp: UserController.to.userInfo.value?.userVal?.exp);
    }
    return null;
  }

  //爵位背景
  static LinearGradient _nobilityGradient(color1, color2) {
    return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: const [0.0, 1.0],
        colors: [color1, color2]);
  }

  @override
  onClearUserInfo() {
    //... 没有可清除的
  }
}
