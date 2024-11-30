import 'package:get/get.dart';
import 'package:youyu/services/live/live_service.dart';

enum WheelGameViewType { primary, advanced }

class WheelGameViewLogic extends GetxController {
  //类型
  Rx<WheelGameViewType> viewType = Rx(WheelGameViewType.primary);

  ///开关动画
  openOrCloseAni(bool isOpen) {
    LiveService().isWheelGameAniOpen.value = isOpen;
  }

  ///赠送
  onSend(int type) {}
}
