import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/modules/live/index/live_index_logic.dart';

///管理员
mixin LiveBaseManagerBsListener {
  //更新管理员列表
  void onManagerUpdate();

  //添加管理
  void onAddManager(int userId);

  //移除管理
  void onRemoveManager(int userId);

  //是否是管理员
  bool onManagerById(int userId);
}

///管理员管理业务
class LiveBaseManagerBs with LiveBaseManagerBsListener {
  List<int> managerList = [];

  @override
  void onManagerUpdate() {
    LiveIndexLogic.to
        .request(AppApi.liveManagerListUrl,
            params: {'room_id': LiveIndexLogic.to.roomId}, isShowToast: false)
        .then((value) {
      managerList.clear();
      List<dynamic> list = value.data['rows'];
      if (list.isNotEmpty) {
        List<int> ids = list.map((e) => e['user_id'] as int).toList();
        managerList.addAll(ids);
      }
      if (managerList.contains(UserController.to.id)) {
        LiveIndexLogic.to.isManager = true;
      } else {
        LiveIndexLogic.to.isManager = false;
      }
    });
  }

  @override
  bool onManagerById(int userId) {
    return managerList.contains(userId);
  }

  @override
  void onAddManager(int userId) {
    if (!managerList.contains(userId)) {
      managerList.add(userId);
    }

    ///更新自己的管理状态
    if (managerList.contains(UserController.to.id)) {
      LiveIndexLogic.to.isManager = true;
    } else {
      LiveIndexLogic.to.isManager = false;
    }
  }

  @override
  void onRemoveManager(int userId) {
    managerList.remove(userId);

    ///更新自己的管理状态
    if (managerList.contains(UserController.to.id)) {
      LiveIndexLogic.to.isManager = true;
    } else {
      LiveIndexLogic.to.isManager = false;
    }
  }

  onClose() {
    managerList.clear();
  }
}
