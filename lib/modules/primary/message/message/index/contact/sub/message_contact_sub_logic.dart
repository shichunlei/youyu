import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MessageContactSubLogic extends AppBaseController {
  late TabModel tabModel;
  late RefreshController subRefreshController;

  int _pageIndex = PageConfig.start;
  String _keyword = "";

  //数据
  List<UserInfo> dataList = [];

  //控制器
  final TextEditingController controller = TextEditingController();

  loadData() {
    setIsLoading = true;
    _fetchList(PageConfig.start);
  }

  _fetchList(int page) {
    _keyword = controller.text;
    request(AppApi.userRelationListUrl, params: {
      'page': page,
      'limit': PageConfig.limit,
      'type': tabModel.id,
      'keyword': _keyword
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

  ///搜索提交
  onSubmitted(String text) {
    if (_keyword != text) {
      loadData();
    }
  }

  ///点击进入用户详情
  onClickUser(UserInfo userInfo) {
    UserController.to.pushToUserDetail(userInfo.id ?? 0, UserDetailRef.other);
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
