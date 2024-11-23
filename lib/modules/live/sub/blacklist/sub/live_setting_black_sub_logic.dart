import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/modules/live/common/notification/live_setting_notify.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LiveSettingBlackSubLogic extends AppBaseController {
  late int roomId;
  late TabModel tabModel;
  late LiveSettingNotify settingNotify;

  ///下拉刷新
  late RefreshController subRefreshController;

  List<UserInfo> dataList = [];

  int _pageIndex = PageConfig.start;

  loadData() {
    setIsLoading = true;
    _fetchList(PageConfig.start);
  }

  ///获取子列表数据
  _fetchList(int page) {
    request(AppApi.roomForbidListUrl, params: {
      'page': page,
      'limit': PageConfig.limit,
      'room_id': roomId,
      'type': tabModel.id
    }).then((value) {
      //1.改变刷新状态
      subRefreshController.refreshCompleted();
      //2.设置索引
      if (page == PageConfig.start) {
        dataList.clear();
      }
      _pageIndex = page + 1;
      //3.设置数据
      List<dynamic> list = value.data['rows'];
      for (Map<String, dynamic> map in list) {
        UserInfo entity = UserInfo.fromJson(map);
        dataList.add(entity);
      }
      //4.判空
      isNoData = false;
      if (list.isEmpty && page == PageConfig.start) {
        isNoData = true;
      }
      //5.判断加载完成
      if (list.isEmpty) {
        subRefreshController.loadNoData();
      } else {
        subRefreshController.loadComplete();
      }
      //6.刷新页面
      setSuccessType();
    }).catchError((e) {
      subRefreshController.refreshCompleted();
      if (dataList.isEmpty) {
        setErrorType(e);
      } else {
        setIsLoading = false;
      }
    });
  }

  @override
  void pullRefresh() {
    super.pullRefresh();
    _fetchList(PageConfig.start);
  }

  @override
  void loadMore() {
    super.loadMore();
    _fetchList(_pageIndex);
  }

  @override
  void reLoadData() {
    super.reLoadData();
    loadData();
  }

  onRemove(UserInfo userInfo) {
    showCommit();
    Map<String, dynamic> params = {
      'room_id': roomId,
      'type': tabModel.id,
      'user_id': userInfo.id,
    };
    request(AppApi.setRoomForbidUrl, params: params).then((value) {
      if (tabModel.id == 1) {
        userInfo.isMuted = 0;
        settingNotify.roomRemoveForbidden(userInfo);
        dataList.remove(userInfo);
        isNoData = dataList.isEmpty;
        setSuccessType();
      } else {
        dataList.remove(userInfo);
        isNoData = dataList.isEmpty;
        setSuccessType();
      }
    });
  }
}
