
import 'package:youyu/models/localmodel/item_title_model.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/modules/setting/account/sub/setpw/set_pw_logic.dart';
import 'package:get/get.dart';
import 'package:youyu/router/router.dart';

enum AccountLogicItemType {
  changePhone,
  setPw,
}

class AccountLogic extends AppBaseController {
  ItemTitleModel setPwItem =
      ItemTitleModel(type: AccountLogicItemType.setPw, title: "");

  ItemTitleModel changePhoneItem = ItemTitleModel(
      type: AccountLogicItemType.changePhone,
      title: "修改手机号",
      subTitle: UserController.to.encryptMobile);

  List<ItemTitleModel> itemList = [];

  @override
  void onInit() {
    super.onInit();
    itemList.addAll([
      changePhoneItem,
      setPwItem,
    ]);
    _updateSetPwTitle();
  }

  _updateSetPwTitle() {
    if (UserController.to.isSetPw == 1) {
      setPwItem.title = "修改密码";
    } else {
      setPwItem.title = "设置密码";
    }
    setSuccessType();
  }

  onClickItem(ItemTitleModel model) {
    if (model.type == AccountLogicItemType.changePhone) {
      Get.toNamed(AppRouter().settingPages.setPhoneChangeRoute.name)
          ?.then((value) {
        changePhoneItem.subTitle = UserController.to.encryptMobile;
        setSuccessType();
      });
    } else if (model.type == AccountLogicItemType.setPw) {
      if (UserController.to.isSetPw == 1) {
        Get.toNamed(AppRouter().settingPages.setPwRoute.name,
            arguments: SetPwType.change);
      } else {
        Get.toNamed(AppRouter().settingPages.setPwRoute.name,
                arguments: SetPwType.set)
            ?.then((value) {
          _updateSetPwTitle();
        });
      }
    }
  }
}
