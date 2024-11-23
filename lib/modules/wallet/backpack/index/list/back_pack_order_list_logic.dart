import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/modules/wallet/backpack/index/list/model/back_pack_order_model.dart';
import 'package:youyu/utils/time_utils.dart' as baseTime;

class BackPackOrderListLogic extends AppBaseController {
  //1 送礼 2 收礼
  int type = 1;

  List<BackPackOrderModel> dataList = [];

  int _pageIndex = PageConfig.start;

  loadData() {
    setIsLoading = true;
    _fetchList(PageConfig.start);
  }

  _fetchList(int page) {
    request(AppApi.giftListUrl, params: {
      'type': type,
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
        Map<String, dynamic> gift = map['gift_list'][0];

        BackPackOrderModel model = BackPackOrderModel();
        if (type == 1) {
          model.title = "送给${map['to_user_data']['nickname']}";
        } else {
          model.title = "收到${map['user_data']['nickname']}";
        }
        model.exTitle = "${gift['gift_name']}x${gift['count']}";
        model.time = baseTime.TimeUtils.customStampStr(
            timestamp: map['create_time'] ?? 0,
            date: "YY-MM-DD hh:mm:ss",
            toInt: false);
        model.image = gift['gift_image'];
        dataList.add(model);
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
