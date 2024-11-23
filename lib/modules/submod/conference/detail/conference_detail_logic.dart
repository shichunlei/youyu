import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/models/conference.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/router/router.dart';
import 'package:youyu/widgets/app/actionsheet/app_action_sheet.dart';
import 'package:youyu/widgets/app/dialog/app_tip_dialog.dart';
import 'package:get/get.dart';

class ConferenceDetailLogic extends AppBaseController {
  //0可申请 1已通过 2 申请中 3 申请被拒绝 4退会申请中 5 退会拒绝
  var state = 0.obs;
  late ConferenceItem item;

  @override
  void onInit() {
    super.onInit();
    state.value = Get.arguments['state'];
    item = Get.arguments['item'];
  }

  //申请公会
  applyConference() {
    showCommit();
    request(AppApi.joinConferenceUrl, params: {'union_id': item.id})
        .then((value) {
      AppTipDialog().showTipDialog("提示", AppWidgetTheme.dark,
          msg: "您已申请，等待会长审核通过。", onlyCommit: true, onCommit: () {
        Get.until(
            (route) => route.settings.name == AppRouter().indexRoute.name);
      });
    });
  }

  //取消申请
  cancelConference() {
    request(AppApi.cancelConferenceUrl, params: {'union_id': item.id})
        .then((value) {
      ToastUtils.show("取消成功");
      Get.back();
    });
  }

  //退出公会
  leaveConference() {
    List<String> data = [state.value == 4 ? "取消退出申请" : "退出公会"];
    AppActionSheet().showSheet(
        theme: AppWidgetTheme.dark,
        actions: data,
        onClick: (index) {
          if (index == 0) {
            if (state.value == 4) {
              showCommit();
              request(AppApi.cancelConferenceUrl, params: {'union_id': item.id})
                  .then((value) {
                state.value = 1;
                ToastUtils.show("取消成功");
              });
            } else {
              showCommit();
              request(AppApi.leaveConferenceUrl,
                  params: {'union_id': item.id}).then((value) {
                state.value = 4;
                ToastUtils.show("您的退出申请已提交，等待会长审核通过。");
              });
            }
          }
        });
  }

}
