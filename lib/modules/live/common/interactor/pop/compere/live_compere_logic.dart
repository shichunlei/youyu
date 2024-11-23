import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/modules/live/common/interactor/pop/compere/pop/live_compere_proportion_view.dart';
import 'package:youyu/modules/live/common/notification/live_setting_notify.dart';
import 'package:youyu/router/router.dart';

class LiveCompereLogic extends AppBaseController {
  late int roomId;
  late LiveSettingNotify settingNotify;

  List<UserInfo> dataList = [];

  fetchList() {
    setIsLoading = true;
    request(AppApi.liveManagerListUrl, params: {'room_id': roomId})
        .then((value) {
      dataList.clear();
      List<dynamic> tempList = (value.data['rows'] as List<dynamic>);
      for (Map<String, dynamic> map in tempList) {
        UserInfo entity = UserInfo.fromJson(map['user_info']);
        entity.isManage = 1;
        if (entity.id != UserController.to.id) {
          entity.proportion = double.parse(map['proportion'] ?? "0").toInt();
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
            arguments: {'roomId': roomId, 'settingNotify': settingNotify})
        ?.then((value) {
      fetchList();
    });
  }

  ///取消管理员
  onCancelManager(UserInfo model) {
    showCommit();
    request(AppApi.setManagerUrl,
            params: {'room_id': roomId, 'user_id': model.id, 'proportion': "0"})
        .then((value) {
      dataList.remove(model);
      isNoData = dataList.isEmpty;
      setSuccessType();
      settingNotify.roomSetManagerNotify(status: 0, userInfo: model);
    });
  }

  //设置比例
  void setProportion(UserInfo model) {
    Get.dialog(Center(
      child: LiveCompereProportionPage(
        proportion: model.proportion ?? 0,
        roomId: roomId.toString(),
        userId: (model.id ?? 0).toString(),
        onRefresh: () {
          fetchList();
          Get.back();
        },
      ),
    ));
  }

  @override
  void reLoadData() {
    super.reLoadData();
    fetchList();
  }
}
