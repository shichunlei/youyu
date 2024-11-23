import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/models/gift_record.dart';
import 'package:youyu/models/room_detail_info.dart';
import 'package:get/get.dart';

class LiveSubGiftNoticeLogic extends AppBaseController {
  RoomDetailInfo? roomInfo;

  List<GiftRecord> dataList = [];

  @override
  void onInit() {
    super.onInit();
    roomInfo = Get.arguments;
    _loadData();
  }

  _loadData() {
    setIsLoading = true;
    request(
      AppApi.roomRewardLogUrl,
      params: {
        'room_id': roomInfo?.id ?? 0,
      },
      isShowToast: false,
    ).then((value) {
      List<dynamic> list = value.data;
      for (Map<String, dynamic> map in list) {
        GiftRecord entity = GiftRecord.fromJson(map);
        dataList.add(entity);
      }
      setSuccessType();
    }).catchError((e) {
      setErrorType(e);
    });
  }

  @override
  void reLoadData() {
    super.reLoadData();
    _loadData();
  }
}
