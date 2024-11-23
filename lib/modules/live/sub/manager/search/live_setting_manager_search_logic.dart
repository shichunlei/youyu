import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/modules/live/common/notification/live_setting_notify.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LiveSettingManagerSearchLogic extends AppBaseController {
  TextEditingController searchController = TextEditingController();

  late int _roomId;
  late LiveSettingNotify _settingNotify;

  List<UserInfo> oriDataList = [];
  List<UserInfo> list = [];

  @override
  void onInit() {
    super.onInit();
    _roomId = Get.arguments['roomId'];
    _settingNotify = Get.arguments['settingNotify'];

    _fetchList();
  }

  _fetchList() {
    setIsLoading = true;
    request(AppApi.liveOnlineUrl,
            params: {"room_id": _roomId}, isShowToast: false, isPrintLog: false)
        .then((value) {
      List<dynamic> tempList = (value.data as List<dynamic>);
      for (Map<String, dynamic> map in tempList) {
        UserInfo entity = UserInfo.fromJson(map);
        if (entity.id != UserController.to.id) {
          oriDataList.add(entity);
        }
      }
      list.addAll(oriDataList);
      isNoData = list.isEmpty;
      setSuccessType();
    }).catchError((e) {
      setErrorType(e);
    });
  }

  search(String keyword) {
    list.clear();
    if (keyword.isNotEmpty) {
      for (UserInfo value in oriDataList) {
        if (value.nickname?.contains(keyword) == true ||
            value.fancyNumber.toString().contains(keyword)) {
          list.add(value);
        }
      }
    } else {
      list.addAll(oriDataList);
    }
    isNoData = list.isEmpty;
    setSuccessType();
  }

  ///取消管理员
  onCancelManager(UserInfo model) {
    showCommit();
    request(AppApi.setManagerUrl,
        params: {'room_id': _roomId, 'user_id': model.id}).then((value) {
      _settingNotify.roomSetManagerNotify(status: 0, userInfo: model);
      model.isManage = 0;
      setSuccessType();
    });
  }

  ///设置管理员
  onSetManager(UserInfo model) {
    showCommit();
    request(AppApi.setManagerUrl,
        params: {'room_id': _roomId, 'user_id': model.id}).then((value) {
      _settingNotify.roomSetManagerNotify(status: 1, userInfo: model);
      model.isManage = 1;
      setSuccessType();
    });
  }

  @override
  void reLoadData() {
    super.reLoadData();
    _fetchList();
  }
}
