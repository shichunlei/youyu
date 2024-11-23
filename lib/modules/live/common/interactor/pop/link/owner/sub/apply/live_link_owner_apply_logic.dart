import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';

class LiveLinkOwnerApplyLogic extends AppBaseController {

  fetchList(int roomId) {
    setIsLoading = true;
    request(AppApi.liveLinkApplyListUrl, params: {'room_id': roomId})
        .then((value) {
      List<dynamic> list = value.data;
      //TODO:test
      isNoData = true;
      setSuccessType();
    }).catchError((e) {
      setErrorType(e);
    });
  }
}
