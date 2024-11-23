import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/modules/submod/rank/list/model/cp_rank_list_model.dart';
import 'package:youyu/modules/submod/rank/list/model/rank_list_top_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:youyu/modules/submod/rank/list/model/week_gift_rank_top_model.dart';

class RankListLogic extends AppBaseController {
  late RefreshController subRefreshController;

  ///参数
  String? roomId;
  TabModel? mainTab;
  TabModel? subTab;

  //数据
  List<dynamic> allData = [];
  List<WeekGift> giftList = [];

  @override
  Future<void> onReady() async {
    super.onReady();
    setIsLoading = true;

    // _fetchData(subTab?.id);
    if (mainTab?.id == 4) {
      _fetchData(subTab?.id);
    } else {
      _fetchData();
    }
  }

  _fetchData([int? id]) {
    //构建动态参数
    Map<String, dynamic> params = {
      'type': mainTab?.id,
      'time_type': subTab?.id
    };

    //如果有id传入 则为周星榜
    if (id != null) {
      params.remove('time_type');
      params['gift_id'] = id;
    }

    request(AppApi.rankUrl, params: params).then((value) {
      if (mainTab?.id == 1 || mainTab?.id == 2) {
        parseData(value.data);
      } else if (mainTab?.id == 3) {
        parseCpData(value.data);
      } else if (mainTab?.id == 4) {
        parseWeekGiftData(value.data);
      }

      if (allData.isEmpty) {
        setEmptyType();
      } else {
        setSuccessType();
      }
    }).catchError((e) {
      setErrorType(e);
    });
  }

  void parseWeekGiftData(Map<String, dynamic> data) {
    List<dynamic> allList = [];
    for (var temp in data['list']) {
      UserInfo userInfo = UserInfo.fromJson(temp['user_info']);

      //将signature改为数值
      userInfo.signature = temp['num'];
      allList.add(userInfo);
    }

    // List<UserInfo> threeList = [];
    for (int i = 0; i < allList.length; i++) {
      // if (i < 3) {
      //   threeList.add(allList[i]);
      // } else {
      //   allData.add(allList[i]);
      // }
      allData.add(allList[i]);
    }

    // if (threeList.isNotEmpty) {
    //   allData.insert(0, RankListTopModel(list: threeList));
    // }
  }

  void parseCpData(Map<String, dynamic> data) {
    List<dynamic> allList = [];
    for (var temp in data['list']) {
      CpRankModel cpInfo = CpRankModel.fromJson(temp);
      allList.add(cpInfo);
    }

    List<CpRankModel> threeList = [];
    for (int i = 0; i < allList.length; i++) {
      if (i < 3) {
        threeList.add(allList[i]);
      } else {
        allData.add(allList[i]);
      }
    }

    if (threeList.isNotEmpty) {
      allData.insert(0, CpRankListTopModel(list: threeList));
    }
  }

  void parseData(Map<String, dynamic> data) {
    List<dynamic> allList = [];
    for (var temp in data['list']) {
      UserInfo userInfo = UserInfo.fromJson(temp);
      allList.add(userInfo);
    }

    List<UserInfo> threeList = [];
    for (int i = 0; i < allList.length; i++) {
      if (i < 3) {
        threeList.add(allList[i]);
      } else {
        allData.add(allList[i]);
      }
    }

    if (threeList.isNotEmpty) {
      allData.insert(0, RankListTopModel(list: threeList));
    }
  }

  @override
  void reLoadData() {
    super.reLoadData();
    setIsLoading = true;
    _fetchData();
  }
}
