import 'package:youyu/models/localmodel/notification_model.dart';
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DiscoverNotificationSubLogic extends AppBaseController {
  late TabModel tabModel;
  late RefreshController subRefreshController;

  int _pageIndex = PageConfig.start;
  List<NotificationModel> dataList = [];

  ///加载入口
  loadData() {
    setIsLoading = true;
    _fetchList(PageConfig.start);
  }

  _fetchList(int page) {
    String url = "";
    if (tabModel.id == 0) {
      url = AppApi.dynamicCommentMsgListUrl;
    } else if (tabModel.id == 1) {
      url = AppApi.dynamicAtMsgListUrl;
    } else if (tabModel.id == 2) {
      url = AppApi.dynamicLikeListUrl;
    }
    request(url,
        params: {
          'page': page,
          'limit': PageConfig.limit,
        },
        isPrintLog: true)
        .then((value) {
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
        NotificationModel entity = NotificationModel.fromJson(map);
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
}
