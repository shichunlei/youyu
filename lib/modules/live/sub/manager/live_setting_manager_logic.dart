
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/modules/live/common/notification/live_setting_notify.dart';
import 'package:get/get.dart';
import 'package:youyu/router/router.dart';

class LiveSettingManagerLogic extends AppBaseController {
  late int _roomId;
  late LiveSettingNotify _settingNotify;

  List<UserInfo> dataList = [];

  @override
  void onInit() {
    super.onInit();
    _roomId = Get.arguments['roomId'];
    _settingNotify = Get.arguments['settingNotify'];

    _fetchList();
  }

  _fetchList() {
    setIsLoading = true;
    request(AppApi.liveManagerListUrl, params: {'room_id': _roomId})
        .then((value) {
      dataList.clear();
      List<dynamic> tempList = (value.data['rows'] as List<dynamic>);
      for (Map<String, dynamic> map in tempList) {
        UserInfo entity = UserInfo.fromJson(map['user_info']);
        entity.isManage = 1;
        if (entity.id != UserController.to.id) {
          dataList.add(entity);
        }
      }
      isNoData = dataList.isEmpty;
      setSuccessType();
    }).catchError((e) {
      setErrorType(e);
    });
  }

  ///添加
  pushToSearch() {
    Get.toNamed(AppRouter().livePages.liveSettingMangerSearchRoute.name,
            arguments: {'roomId': _roomId, 'settingNotify': _settingNotify})
        ?.then((value) {
      _fetchList();
    });
  }

  ///取消管理员
  onCancelManager(UserInfo model) {
    showCommit();
    request(AppApi.setManagerUrl,
        params: {'room_id': _roomId, 'user_id': model.id}).then((value) {
      dataList.remove(model);
      isNoData = dataList.isEmpty;
      setSuccessType();
      _settingNotify.roomSetManagerNotify(status: 0, userInfo: model);
    });
  }

  ///设置管理员 (基本用不到)
  onSetManager(UserInfo model) {
    showCommit();
    request(AppApi.setManagerUrl,
        params: {'room_id': _roomId, 'user_id': model.id}).then((value) {});
  }

  @override
  void reLoadData() {
    super.reLoadData();
    _fetchList();
  }
}
