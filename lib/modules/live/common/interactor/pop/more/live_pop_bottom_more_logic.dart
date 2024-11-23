import 'package:youyu/models/localmodel/menu_model.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/controllers/base/base_controller.dart';

enum LivePopBottomMoreType {
  share,
  closeAni,
  closeScreen,
  clearML,
  clearScreen,
  music,
  setting,
  zc
}

class LivePopBottomMoreLogic extends AppBaseController {
  //是否是主播
  bool isOwner = false;

  //是否是管理
  bool isManager = false;

  //是否关闭动效
  bool isCloseAni = false;

  //是否关闭公屏
  bool isCloseScreen = false;

  List<MenuModel> list = [];

  fetchData() {
    if (isManager || isOwner) {
      list.addAll([
        //TODO:暂时隐藏
        // MenuModel(
        //     type: LivePopBottomMoreType.share,
        //     title: "分享",
        //     icon: AppResource().liveBMore1),
        MenuModel(
            type: LivePopBottomMoreType.closeAni,
            title: isCloseAni ? "打开动效" : "关闭动效",
            icon: AppResource().liveBMore2),
        MenuModel(
            type: LivePopBottomMoreType.closeScreen,
            title: isCloseScreen ? "打开公屏" : "关闭公屏",
            icon: AppResource().liveBMore3),
        MenuModel(
            type: LivePopBottomMoreType.clearML,
            title: "清除魅力",
            icon: AppResource().liveBMore4),
        MenuModel(
            type: LivePopBottomMoreType.clearScreen,
            title: "清屏",
            icon: AppResource().liveBMore5),
        //TODO:暂时隐藏
        // MenuModel(
        //     type: LivePopBottomMoreType.music,
        //     title: "音乐",
        //     icon: AppResource().liveBMore6),
        MenuModel(
            type: LivePopBottomMoreType.setting,
            title: "设置",
            icon: AppResource().liveBMore7)
      ]);
    } else {
      list.addAll([
        //TODO:暂时隐藏
        // MenuModel(
        //     type: LivePopBottomMoreType.share,
        //     title: "分享",
        //     icon: AppResource().liveBMore1),
        MenuModel(
            type: LivePopBottomMoreType.closeAni,
            title: isCloseAni ? "打开动效" : "关闭动效",
            icon: AppResource().liveBMore2),
        MenuModel(
            type: LivePopBottomMoreType.clearScreen,
            title: "清屏",
            icon: AppResource().liveBMore5),
      ]);
    }

    if (isOwner) {
      list.add(MenuModel(
          type: LivePopBottomMoreType.zc,
          title: "设置主持",
          icon: AppResource().liveZc));
    }
  }
}
