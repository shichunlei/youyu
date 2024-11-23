import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/my_getuserinfo.dart';

class SearchUserListLogic extends AppBaseController {
  List<UserInfo> list = [];

  //关注/取消关注好友
  onClickFocus(UserInfo model) {
    UserController.to.onFocusUserOrCancel(model,onUpdate: () {
        update();
    });
  }
}
