import 'package:youyu/controllers/app_controller.dart';
import 'package:youyu/controllers/user/sub/abs/user_sub_control.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/user_level.dart';
import 'package:get/get.dart';

///等级管理
class UserLevelControl extends UserSubControl {
  //等级列表
  var levelList = <UserLevel>[].obs;

  @override
  onUpdateUserInfo() {
    List<List<UserLevel>> list =
        AppController.to.appInitData.value?.userLevelList ?? [];
    List<UserLevel> tempList = [];

    for (int index = 0; index < list.length; index++) {
      //待插入的数据
      UserLevel newElement = UserLevel(img: "", exp: 0);
      //每10个一组列表
      List<UserLevel> subList = list[index];
      //遍历赋值
      for (int i = 0; i < subList.length; i++) {
        //每一个子项
        UserLevel element = subList[i];
        if (i == 0) {
          newElement.minLevel = (10 * index) + 1 + i;
          newElement.minExp = element.exp;
        } else if (i == subList.length - 1) {
          newElement.maxLevel = (10 * index) + 1 + i;
          newElement.maxExp = element.exp;
          newElement.img = element.img;
        }
      }
      //插入
      tempList.add(newElement);
    }
    levelList.value = tempList;
  }

  //自己对应等级信息
  UserCurLevelModel myCurLevelModel() {
    return _userCurLevelModel(
        UserController.to.userInfo.value?.userVal?.exp ?? 0);
  }

  //用户对应等级
  UserCurLevelModel _userCurLevelModel(int exp) {
    UserLevel? curTempModel;
    for (int index = 0; index < levelList.length; index++) {
      UserLevel level = levelList[index];
      if (exp >= (level.minExp ?? 0) && exp <= (level.maxExp ?? 0)) {
        curTempModel = level;
        break;
      }
    }
    int currentLevel = 0;
    int limit = 0;
    int nextLevel = -1;
    if (curTempModel != null && (curTempModel.maxExp ?? 0) > 0) {
      //计算当前等级
      currentLevel = int.parse(
          UserController.to.userInfo.value?.userVal?.levelName ?? "0");
      //计算剩余
      limit = (curTempModel.maxExp ?? 0) - exp;
      //计算下一等级
      if ((currentLevel + 1) <= (levelList.last.maxLevel ?? 0)) {
        nextLevel = currentLevel + 1;
      }
      return UserCurLevelModel(
          limitExp: limit,
          curLevel: currentLevel,
          nextLevel: nextLevel,
          exp: exp,
          img: curTempModel.img);
    }

    return UserCurLevelModel(
        limitExp: limit,
        curLevel: levelList.last.maxLevel ?? 0,
        nextLevel: nextLevel,
        exp: exp,
        img: levelList.last.img);
  }

  @override
  onClearUserInfo() {
    //... 没有可清除的
  }
}

///用户当前等级模型
class UserCurLevelModel {
  UserCurLevelModel(
      {this.limitExp,
      required this.curLevel,
      this.nextLevel,
      required this.exp,
      required this.img});

  //当前经验
  final int exp;

  //还需多少经验值
  final int? limitExp;

  //当前等级
  final int? curLevel;

  //下一等级
  final int? nextLevel;

  //图片
  final String img;
}
