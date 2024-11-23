import 'package:youyu/controllers/user/sub/abs/user_sub_control.dart';
import 'package:get/get.dart';

class UserSetControl extends UserSubControl {


  //是否开启消息免打扰
  var isOpenDisturb = false.obs;

  //是否通讯录隐身
  var isBookAddressHidden = false.obs;

  @override
  onClearUserInfo() {

  }

  @override
  onUpdateUserInfo() {

  }
}
