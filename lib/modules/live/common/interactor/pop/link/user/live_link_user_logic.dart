import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';

class LiveLinkUserApplyLogic extends AppBaseController {

  fetchList(int roomId) {
    setIsLoading = true;
    request(AppApi.liveLinkApplyUrl, params: {'room_id': roomId}).then((value) {
      List<dynamic> list = value.data;
      //TODO:test
      isNoData = true;
      setSuccessType();
    }).catchError((e) {
      setErrorType(e);
    });
  }
}
