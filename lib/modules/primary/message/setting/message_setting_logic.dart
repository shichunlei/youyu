
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/modules/submod/report/report_logic.dart';
import 'package:get/get.dart';
import 'package:youyu/router/router.dart';

enum MessageSettingEventType {
  remark, //备注
  report, //举报
  black, //拉黑
  focus //关注
}

class MessageSettingLogic extends AppBaseController with UserBlackListener {
  int userId = 0;

  ///用户信息
  UserInfo? targetUserInfo;

  @override
  void onInit() {
    super.onInit();
    userId = Get.arguments['userId'];

    targetUserInfo = Get.arguments['targetUserInfo'];

    UserController.to.addUserBlackObserver(this);

    if (targetUserInfo == null) {
      _loadData();
    } else {
      setSuccessType();
    }
  }

  _loadData() {
    setIsLoading = true;
    //获取他人信息
    UserController.to.fetchOtherInfo(userId).then((value) {
      targetUserInfo = UserInfo.fromJson(value.data);
      setSuccessType();
    }).catchError((e) {
      setErrorType(e);
    });
  }

  ///点击事件
  onClickEvent(MessageSettingEventType eventType) {
    switch (eventType) {
      case MessageSettingEventType.remark:
        {
          Get.toNamed(AppRouter().messagePages.messageRemarkRoute.name,
              arguments: {"userId": userId, "targetUserInfo": targetUserInfo});
        }
        break;
      case MessageSettingEventType.report:
        {
          Get.toNamed(AppRouter().otherPages.reportRoute.name,
              arguments: {'type': ReportType.user, 'id': userId.toString()});
        }
        break;
      case MessageSettingEventType.black:
        UserController.to.onBlackUserOrCancel(targetUserInfo);
        break;
      case MessageSettingEventType.focus:
        {
          UserController.to.onFocusUserOrCancel(targetUserInfo, onUpdate: () {
            //通知刷新
            UserController.to.notifyChangeUserFocus(targetUserInfo!);
            setSuccessType();
          });
        }
        break;
    }
  }

  ///UserBlackListener
  @override
  onUserBlackChanged(UserInfo userInfo) {
    if (userInfo.id == targetUserInfo?.id) {
      targetUserInfo?.isBlock = userInfo.isBlock;
      setSuccessType();
    }
  }

  @override
  void reLoadData() {
    super.reLoadData();
    _loadData();
  }

  @override
  void onClose() {
    UserController.to.removeUserBlackObserver(this);
    super.onClose();
  }
}
