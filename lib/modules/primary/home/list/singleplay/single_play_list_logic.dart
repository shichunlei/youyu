import 'package:youyu/services/http/http_error.dart';

import 'package:youyu/services/http/http_response.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/models/room_list_item.dart';
import 'package:youyu/modules/primary/home/list/singleplay/model/single_play_hot_model.dart';

class SinglePlayListLogic extends AppBaseController {
  ///总数据
  List<dynamic> allData = [];

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  ///加载数据
  _loadData() {
    if (allData.isEmpty) {
      setIsLoading = true;
    }
    Future.wait<HttpResponse?>([_fetchHot()]).then((value) {
      //下拉状态
      refreshController.refreshCompleted();
      setIsLoading = false;
      //判断成功/失败
      if (value[0] == null && value[1] == null) {
        if (allData.isEmpty) {
          setErrorType(HttpErrorException(errorType: HttpErrorType.web));
        }
      } else {
        allData.clear();
        List<RoomListItem> hotList = [];
        if (value[0] != null) {
          ///热门
          List<dynamic> list = value[0]?.data;
          for (Map<String, dynamic> map in list) {
            RoomListItem entity = RoomListItem.fromJson(map);
            hotList.add(entity);
          }
          if (hotList.isNotEmpty) {
            allData.add(SinglePlayHotModel(
                    "热门房间", AppResource().homeFirTag,
                    list: hotList)
                .dealWithData());
          }
        }

        ///推荐
        // List<RoomListItem> recommendList = [];
        // if (value[1] != null) {
        //   List<dynamic> list = value[1]?.data;
        //   for (Map<String, dynamic> map in list) {
        //     RoomListItem entity = RoomListItem.fromJson(map);
        //     recommendList.add(entity);
        //   }
        //   if (recommendList.isNotEmpty) {
        //     allData.add(SinglePlayRecommendModel(
        //         "推荐房间", AppResource().homeRecommendTag,
        //         list: recommendList));
        //   }
        // }
        //判断是否有数据
        if (hotList.isEmpty) {
        // if (hotList.isEmpty && recommendList.isEmpty) {
          setEmptyType();
        } else {
          setSuccessType();
        }
      }
    });
  }

  ///热门房间
  Future<HttpResponse?> _fetchHot() async {
    try {
      return await request(AppApi.homeTypeListUrl, params: {
        'page': PageConfig.start,
        'limit': PageConfig.maxLimit,
        'type_id': 21
      });
    } catch (e) {
      return null;
    }
  }

  @override
  void pullRefresh() {
    super.pullRefresh();
    _loadData();
  }

  @override
  void reLoadData() {
    super.reLoadData();
    _loadData();
  }
}
