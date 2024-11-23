import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/sub/user_level_control.dart';
import 'package:youyu/controllers/user/user_controller.dart';

class LevelLogic extends AppBaseController {
  late UserCurLevelModel curLevelModel;

  @override
  void onInit() {
    super.onInit();
    curLevelModel = UserController.to.levelControl.myCurLevelModel();
    setSuccessType();
  }
}
