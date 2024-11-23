import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/models/room_list_item.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:flutter/cupertino.dart';

class FollowLiveLogic extends AppBaseController {
  List<RoomListItem> allData = [];
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  _loadData() {
    setIsLoading = true;
    request(AppApi.liveFocusListUrl,
        params: {'keyword': searchController.text}).then((value) {
      List<dynamic> list = value.data;
      allData.clear();
      for (Map<String, dynamic> map in list) {
        RoomListItem entity = RoomListItem.fromJson(map);
        allData.add(entity);
      }
      isNoData = allData.isEmpty;
      setSuccessType();
    }).catchError((e) {
      setErrorType(e);
    });
  }

  ///进入直播间
  onClickLive(RoomListItem itemModel) {
    LiveService().pushToLive(itemModel.id, itemModel.groupId);
  }

  ///取消关注直播间
  onClickCancelFocus(RoomListItem item) {
    showCommit();
    request(AppApi.liveFocusUrl, params: {'room_id': item.id})
        .then((value) {
      allData.remove(item);
      isNoData = allData.isEmpty;
      setSuccessType();
    });
  }

  ///事件
  //搜索
  onClickSearch() {
    _loadData();
  }

  @override
  void reLoadData() {
    super.reLoadData();
    _loadData();
  }
}
