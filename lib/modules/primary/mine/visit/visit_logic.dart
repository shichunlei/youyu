
import 'package:youyu/models/localmodel/item_title_model.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/models/visit.dart';
import 'package:youyu/utils/number_ext.dart';

class VisitLogic extends AppBaseController {
  ///数量
  List<ItemTitleModel> countList = [];

  ///列表
  List<VisitInfo> dataList = [];
  int _pageIndex = PageConfig.start;

  ///蒙板图
  List<String> maskList = [
    AppResource().maskImg1,
    AppResource().maskImg2,
    AppResource().maskImg3
  ];

  //TODO:先默认
  bool isVip = true;

  @override
  void onInit() {
    super.onInit();
    setNoneType();
    loadData();
  }

  ///加载入口
  loadData() {
    setIsLoading = true;
    _fetchList(PageConfig.start);
  }

  _fetchList(int page) {
    request(AppApi.userVisitorListUrl, params: {
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
      var data = value.data;
      //总访问人数
      String allPeople = data['all_people'].toString();
      countList.add(ItemTitleModel(
          title: "总访问人数", subTitle: int.parse(allPeople).showNum()));
      //今日人数
      String todayPeople = data['today_people'].toString();
      countList.add(ItemTitleModel(
          title: "今日人数", subTitle: int.parse(todayPeople).showNum()));
      //今日次数
      String todayNum = "0";
      if (data['today_num'] != null) {
        todayNum = data['today_num'].toString();
      }
      countList.add(ItemTitleModel(
          title: "今日次数", subTitle: int.parse(todayNum).showNum()));

      //3.设置数据
      List<dynamic> list = data['list']['data'];
      for (Map<String, dynamic> map in list) {
        VisitInfo entity = VisitInfo.fromJson(map);
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
      setErrorType(e);
    });
  }

  updateVipState() {
    isVip = !isVip;
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
}
