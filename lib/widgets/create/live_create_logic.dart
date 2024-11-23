import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/services/live/live_service.dart';

class LiveCreateLogic extends AppBaseController {
  bool isLoadFailed = false;

  ///获取分类列表
  fetchList() async {
    try {
      await LiveService().fetchLiveClsList();
      update();
    } catch (e) {
      isLoadFailed = true;
      update();
    }
  }
}
