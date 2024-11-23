import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/my_getuserinfo.dart';

class SettingBlackLogic extends AppBaseController with UserBlackListener {
  List<UserInfo> dataList = [];

  int _pageIndex = PageConfig.start;

  @override
  void onInit() {
    super.onInit();
    loadData();
    UserController.to.addUserBlackObserver(this);
  }

  ///加载入口
  loadData() {
    setIsLoading = true;
    _fetchList(PageConfig.start);
  }

  ///获取子列表数据
  _fetchList(int page) {
    request(AppApi.userBlockListUrl, params: {
      'page': page,
      'limit': PageConfig.limit,
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
        UserInfo entity = UserInfo.fromJson(map['block_user_info']);
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

  ///移出黑名单
  onClickRemove(UserInfo userInfo) {
    UserController.to.onBlackUserOrCancel(userInfo);
  }

  ///UserBlackListener
  @override
  onUserBlackChanged(UserInfo userInfo) {
    dataList.removeWhere((element) => element.id == userInfo.id);
    isNoData = dataList.isEmpty;
    setSuccessType();
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

  @override
  void onClose() {
    UserController.to.removeUserBlackObserver(this);
    super.onClose();
  }
}
