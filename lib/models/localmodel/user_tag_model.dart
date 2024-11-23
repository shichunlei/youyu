import 'package:youyu/controllers/user/sub/user_level_control.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/models/user_nobility.dart';

///用户标签
enum UserTagType {
  vip, //vip
  sVip, //svip
  level, //等级
  nobility, //爵位
  manger //管理
}

class UserTagModel {
  UserTagModel({
    required this.type,
    this.level,
    this.nobility,
  });

  final UserTagType type;
  UserCurLevelModel? level;
  UserNobilityModel? nobility;

  static List<UserTagModel> userTags(UserInfo userInfo) {
    List<UserTagModel> list = [];

    //爵位
    if ((userInfo.userVal?.titleId ?? 0) > 0) {
      UserNobilityModel nobilityModel = UserNobilityModel(
          id: userInfo.userVal?.titleId ?? 0,
          name: userInfo.userVal?.titleName ?? "",
          img: userInfo.userVal?.titleImg ?? "");
      UserTagModel nobilityTagModel =
          UserTagModel(type: UserTagType.nobility, nobility: nobilityModel);
      list.add(nobilityTagModel);
    }

    //vip
    if (userInfo.isSVip) {
      list.add(UserTagModel(type: UserTagType.sVip));
    } else if (userInfo.isVip) {
      list.add(UserTagModel(type: UserTagType.vip));
    }

    //等级
    if ((userInfo.userVal?.levelId ?? -1) > 0) {
      UserTagModel levelTagModel = UserTagModel(
          type: UserTagType.level,
          level: UserCurLevelModel(
              curLevel: int.parse((userInfo.userVal?.levelName ?? "0")),
              exp: userInfo.userVal?.exp ?? 0,
              img: userInfo.userVal?.levelImg ?? ""));
      list.add(levelTagModel);
    }
    return list;
  }
}
