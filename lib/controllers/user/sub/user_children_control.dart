import 'package:youyu/utils/sp_utils.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:get/get.dart';

import 'abs/user_sub_control.dart';

///青少年模式管理
class UserChildrenControl extends UserSubControl {
  final String _keyChildren = 'childrenKey';
  final String _keyChildrenPw = 'childrenPwKey';

  var isOpenChildren = false.obs;

  String _childrenPw = "";

  String get childrenPw => _childrenPw;

  @override
  onUpdateUserInfo() {
    initChildrenData();
  }

  initChildrenData() async {
    isOpenChildren.value = await StorageUtils.getBoolValue(
        "$_keyChildren-${UserController.to.id}");
    _childrenPw = await StorageUtils.getValue(
        "$_keyChildrenPw-${UserController.to.id}", "");
  }

  //更新青少年模式状态
  updateChildrenData(bool isOpen, {String? password}) async {
    isOpenChildren.value = isOpen;
    await StorageUtils.setBoolValue(
        "$_keyChildren-${UserController.to.id}", isOpenChildren.value);
    if (isOpen) {
      _childrenPw = password ?? "";
    } else {
      _childrenPw = "";
    }
    await StorageUtils.setValue(
        "$_keyChildrenPw-${UserController.to.id}", _childrenPw);
  }

  @override
  onClearUserInfo() {
    //... 没有可清除的
  }

}
