
import 'package:youyu/models/localmodel/menu_model.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/controllers/base/base_controller.dart';

enum LivePopShareType {
  wx,
  wxFriend,
  qq,
  qqSpace,
  mocha,
}

class LivePopShareLogic extends AppBaseController {
  List<MenuModel> list = [
    MenuModel(
        type: LivePopShareType.wx,
        title: "微信",
        icon: AppResource().liveShareWx),
    MenuModel(
        type: LivePopShareType.wxFriend,
        title: "朋友圈",
        icon: AppResource().liveShareWxFriend),
    MenuModel(
        type: LivePopShareType.qq,
        title: "QQ",
        icon: AppResource().liveShareQQ),
    MenuModel(
        type: LivePopShareType.qqSpace,
        title: "QQ空间",
        icon: AppResource().liveShareQQSpace),
    MenuModel(
        type: LivePopShareType.mocha,
        title: "抹茶好友",
        icon: AppResource().liveShareMocha),
  ];
}
