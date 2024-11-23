import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/models/conference.dart';

class ConferenceIndexLogic extends AppBaseController {
  ///数据
  List<ConferenceItem> dataList = [];

  int _pageIndex = PageConfig.start;

  String fancyNumber = "";

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  ///加载入口
  loadData() {
    setIsLoading = true;
    _fetchList(PageConfig.start);
  }

  ///获取子列表数据
  _fetchList(int page) {
    request(AppApi.conferenceUrl, params: {
      'page': page,
      'limit': PageConfig.limit,
      'fancy_number': fancyNumber
    }).then((value) {
      //1.改变刷新状态
      refreshController.refreshCompleted();
      //2.设置索引
      if (page == PageConfig.start) {
        dataList.clear();
      }
      _pageIndex = page + 1;
      //3.设置数据
      List<dynamic> list = value.data['data'];
      for (Map<String, dynamic> map in list) {
        ConferenceItem entity = ConferenceItem.fromJson(map);
        dataList.add(entity);
      }
      //4.判空
      isNoData = false;
      if (list.isEmpty && page == PageConfig.start) {
        isNoData = true;
      }
      //5.判断加载完成
      if (list.isEmpty) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
      //6.刷新页面
      setSuccessType();
    }).catchError((e) {
      refreshController.refreshCompleted();
      if (dataList.isEmpty) {
        setErrorType(e);
      } else {
        setIsLoading = false;
      }
    });
  }

  void onClickSearch(String keyword) {
    fancyNumber = keyword;
    setIsLoading = true;
    pullRefresh();
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
