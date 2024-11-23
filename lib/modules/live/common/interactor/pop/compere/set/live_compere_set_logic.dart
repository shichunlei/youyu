import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/modules/live/common/notification/live_setting_notify.dart';

class LiveCompereSetModel {
  LiveCompereSetModel({
    required this.type,
    required this.list,
  });

  //1.添加 2.取消
  final int type;
  final List<UserInfo> list;
}

class LiveCompereSetLogic extends AppBaseController {
  late int roomId;
  late LiveSettingNotify settingNotify;

  //已有主持
  late List<UserInfo> hasDataList;
  List<UserInfo> waitDataList = [];

  //待添加的主持
  List<LiveCompereSetModel> dataList = [];

  late Function(UserInfo model) onAdd;
  late Function(UserInfo model) onRemove;

  fetchList() {
    setIsLoading = true;
    request(AppApi.liveOnlineUrl,
            params: {"room_id": roomId}, isShowToast: false, isPrintLog: false)
        .then((value) {
      List<dynamic> tempList = (value.data as List<dynamic>);
      for (Map<String, dynamic> map in tempList) {
        UserInfo entity = UserInfo.fromJson(map);
        if (entity.id != UserController.to.id) {
          bool isHas = false;
          for (UserInfo userInfo in hasDataList) {
            if (entity.id == userInfo.id) {
              isHas = true;
              break;
            }
          }
          if (!isHas) {
            waitDataList.add(entity);
          }
        }
      }
      isNoData = waitDataList.isEmpty && hasDataList.isEmpty;

      _updateDataList();
      setSuccessType();
    }).catchError((e) {
      setErrorType(e);
    });
  }

  ///取消管理员
  onCancelManager(UserInfo model) {
    showCommit();
    request(AppApi.setManagerUrl,
            params: {'room_id': roomId, 'user_id': model.id, 'proportion': 0})
        .then((value) {
      settingNotify.roomSetManagerNotify(status: 0, userInfo: model);
      model.isManage = 0;

      hasDataList.remove(model);
      waitDataList.add(model);
      onRemove(model);
      _updateDataList();
      setSuccessType();
    });
  }

  ///设置管理员
  onSetManager(UserInfo model) {
    showCommit();
    request(AppApi.setManagerUrl,
            params: {'room_id': roomId, 'user_id': model.id, 'proportion': "0"})
        .then((value) {
      settingNotify.roomSetManagerNotify(status: 1, userInfo: model);
      model.isManage = 1;

      hasDataList.add(model);
      waitDataList.remove(model);
      onAdd(model);
      _updateDataList();
      setSuccessType();
    });
  }

  _updateDataList() {
    dataList.clear();
    if (hasDataList.isNotEmpty) {
      dataList.add(LiveCompereSetModel(type: 2, list: hasDataList));
    }
    if (waitDataList.isNotEmpty) {
      dataList.add(LiveCompereSetModel(type: 1, list: waitDataList));
    }
  }

  @override
  void reLoadData() {
    super.reLoadData();
    fetchList();
  }
}
