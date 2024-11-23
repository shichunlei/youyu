import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/dynamic_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/discover_item.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/services/voice_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DiscoverSubListLogic extends AppBaseController
    with
        DynamicPublishListener,
        UserFocusListener,
        DynamicUserLikeOrCommentListener,
        DynamicDeleteListener {
  late TabModel tabModel;
  late RefreshController subRefreshController;
  int _pageIndex = PageConfig.start;
  List<DiscoverItem> dataList = [];

  @override
  void onInit() {
    super.onInit();
    DynamicController.to.addPublishObserver(this);
    UserController.to.addUserFocusObserver(this);
    DynamicController.to.addUserLikeOrCommentObserver(this);
    DynamicController.to.addDeleteObserver(this);
  }

  ///加载入口
  loadData() {
    setIsLoading = true;
    _fetchList(PageConfig.start);
  }

  _fetchList(int page) {
    request(AppApi.dynamicList,
            params: {
              'page': page,
              'limit': PageConfig.limit,
              'type': tabModel.id
            },
            isPrintLog: true)
        .then((value) {
      VoiceService().stopAudio();
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
        DiscoverItem entity = DiscoverItem.fromJson(map);
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

  ///DynamicPublishListener
  @override
  onPublishSuccess() {
    _fetchList(PageConfig.start);
  }

  ///DynamicUserFocusListener
  @override
  onUserFocusChanged(UserInfo userInfo) {
    for (DiscoverItem item in dataList) {
      if (item.userInfo?.id == userInfo.id) {
        item.userInfo?.meIsFocusUser = userInfo.meIsFocusUser;
      }
      setSuccessType();
    }
  }

  ///DynamicUserLikeOrCommentListener
  @override
  onUserLikeOrCommentChanged(DiscoverItem? item) {
    for (DiscoverItem temp in dataList) {
      if (temp.id == item?.id) {
        temp.isLike = item?.isLike;
        temp.commentCount = item?.commentCount;
      }
      setSuccessType();
    }
  }

  ///关注
  onClickFocus(DiscoverItem? model) {
    UserController.to.onFocusUserOrCancel(model?.userInfo, onUpdate: () {
      for (DiscoverItem item in dataList) {
        if (item.userInfo?.id == model?.userInfo?.id) {
          item.userInfo?.meIsFocusUser = model?.userInfo?.meIsFocusUser;
        }
        setSuccessType();
      }
    });
  }

  ///DynamicDeleteListener
  @override
  onDynamicDelete(DiscoverItem? item) {
    dataList.removeWhere((element) => item?.id == element.id);
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
    loadData();
  }

  @override
  void onClose() {
    super.onClose();
    DynamicController.to.removePublishObserver(this);
    UserController.to.removeUserFocusObserver(this);
    DynamicController.to.removeUserLikeOrCommentObserver(this);
    DynamicController.to.removeDeleteObserver(this);
  }
}
