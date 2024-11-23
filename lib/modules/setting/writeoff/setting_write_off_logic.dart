import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/auth_controller.dart';
import 'package:youyu/controllers/base/base_controller.dart';

class SettingWriteOffLogic extends AppBaseController {
  
  
  ///提交注销
  void commit() {
    showCommit();
    request(AppApi.userWriteOffUrl).then((value) {
      AuthController.to.logout(initiative: true);
    });
  }

  
  
}
