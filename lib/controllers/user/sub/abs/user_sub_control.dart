import 'package:youyu/controllers/base/base_controller.dart';

abstract class UserSubControl extends AppBaseController {

  ///刷新数据
  onUpdateUserInfo();

  ///清空用户信息
  onClearUserInfo();

}
