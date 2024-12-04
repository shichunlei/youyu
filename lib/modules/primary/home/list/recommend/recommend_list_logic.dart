import 'package:card_swiper/card_swiper.dart';

import 'package:youyu/config/api.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/controllers/app_controller.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/models/banner_model.dart';
import 'package:youyu/models/recommend_list_model.dart';
import 'package:youyu/models/room_list_item.dart';
import 'package:youyu/modules/primary/home/list/recommend/model/recommend_tabbar_jump_model.dart';
import 'model/recommend_amusement_model.dart';
import 'model/recommend_banner_model.dart';
import 'model/recommend_making_model.dart';

class RecommendListLogic extends AppBaseController {
  ///总数据
  List<dynamic> allData = [];

  final SwiperController tzController = SwiperController();

  @override
  void onReady() {
    super.onReady();
    setIsLoading = true;
    fetchData();
  }

  fetchData() {
    request(AppApi.homeRecommendUrl, isPrintLog: true).then((value) {
      allData.clear();
      RecommendListModel model = RecommendListModel.fromJson(value.data);
      //banner
      if (model.banner != null && model.banner?.isNotEmpty == true) {
        fetchBanner(model.banner!);
      }
      fetchTabBarJump();
      if (model.list != null) {
        List<RoomListItem> allList = model.list ?? [];
        List<RoomListItem> top3List = [];
        List<RoomListItem> recommendList = [];
        for (int i = 0; i < allList.length; i++) {
          RoomListItem item = allList[i];
          if (i < 3) {
            top3List.add(item);
          } else {
            recommendList.add(item);
          }
        }
        //热门房间
        if (top3List.isNotEmpty) {
          fetchHot(top3List);
        }
        //推荐房间
        if (recommendList.isNotEmpty) {
          fetchRecommend(recommendList);
        }
      } else {
        setEmptyType();
      }
      refreshController.refreshCompleted();
      setSuccessType();
    }).catchError((e) {
      refreshController.refreshCompleted();
      setIsLoading = false;
      if (allData.isEmpty) {
        setErrorType(e);
      }
    });
  }

  fetchBanner(List<BannerModel> list) {
    RecommendBannerModel model = RecommendBannerModel(bannerList: list);
    AppController.to.bannerModel.value = model;
    allData.add(model);
  }

  fetchTabBarJump() {
    RecommendTabbarJumpModel model = RecommendTabbarJumpModel();
    allData.add(model);
  }

  fetchHot(List<RoomListItem> list) {
    allData.add(
        RecommendHotModel("热门房间", AppResource().homeAmusementLogo, list: list));
  }

  fetchRecommend(List<RoomListItem> list) {
    allData.add(
        RecommendHomeModel("推荐房间", AppResource().homeMarkingLogo, list: list));
  }

  @override
  void pullRefresh() {
    super.pullRefresh();
    fetchData();
  }

  @override
  void reLoadData() {
    super.reLoadData();
    setIsLoading = true;
    fetchData();
  }
}
