import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/modules/wallet/exchange/bean/account_model.dart';
import 'package:get/get.dart';

class WithDrawAccountChangeLogic extends AppBaseController {
  AccountModel? accountModel;

  @override
  void onInit() {
    super.onInit();
    accountModel = Get.arguments;
    setSuccessType();
  }

  //加密手机号
  String get encryptMobile {
    if ((accountModel?.account.length ?? 0) > 7) {
      return accountModel!.account
          .replaceRange(3, (accountModel?.account.length ?? 0) - 4, '***');
    }
    return accountModel?.account ?? "";
  }
}
