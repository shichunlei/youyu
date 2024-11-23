import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/models/room_list_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeTypeSubListLogic extends AppBaseController {
  ///入参

  //当前分类
  late TabModel tabModel;

  ///数据
  List<RoomListItem> dataList = [];

  ///下拉刷新
  late RefreshController subRefreshController;

  int _pageIndex = PageConfig.start;

  ///加载入口
  loadData() {
    setIsLoading = true;
    _fetchList(PageConfig.start);
  }

  ///获取子列表数据
  _fetchList(int page) {
    request(AppApi.homeTypeListUrl, params: {
      'page': page,
      'limit': PageConfig.limit,
      'type_id': tabModel.id
    }).then((value) {
      //1.改变刷新状态
      subRefreshController.refreshCompleted();
      //2.设置索引
      if (page == PageConfig.start) {
        dataList.clear();
      }
      _pageIndex = page + 1;
      //3.设置数据
      List<dynamic> list = value.data;
      for (Map<String, dynamic> map in list) {
        RoomListItem entity = RoomListItem.fromJson(map);
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
    setIsLoading = true;
    _fetchList(PageConfig.start);
  }
}
