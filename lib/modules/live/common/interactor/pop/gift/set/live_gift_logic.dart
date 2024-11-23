import 'package:get/get.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/models/gift.dart';
import 'package:youyu/modules/live/index/live_index_logic.dart';

class LiveGiftLogic extends AppBaseController {
  static List<Gift?> get giftList => LiveIndexLogic.to.barGiftList;
  RxInt selectIndex = 0.obs;
}
