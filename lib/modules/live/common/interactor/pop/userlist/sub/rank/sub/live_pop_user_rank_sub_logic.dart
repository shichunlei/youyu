import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LivePopUserRankSubLogic extends AppBaseController {
  late RefreshController subRefreshController;

  ///参数
  int? roomId;
  TabModel? mainTab;
  TabModel? subTab;

  //数据
  List<dynamic> allData = [];

  fetchData() {
    request(AppApi.rankUrl, params: {
      'type': mainTab?.id,
      'time_type': subTab?.id,
      'room_id': roomId ?? "0"
    }).then((value) {
      for (var temp in value.data['list']) {
        UserInfo item = UserInfo.fromJson(temp);
        allData.add(item);
      }
      if (allData.isNotEmpty) {
        isNoData = false;
      } else {
        isNoData = true;
      }
      setSuccessType();
    }).catchError((e) {
      setErrorType(e);
    });
  }

  @override
  void reLoadData() {
    super.reLoadData();
    setIsLoading = true;
    fetchData();
  }
}
