import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/modules/submod/report/report_logic.dart';
import 'package:youyu/router/router.dart';
import 'package:youyu/services/im/im_service.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/widgets/app/actionsheet/app_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDetailLogic extends AppBaseController
    with
        GetSingleTickerProviderStateMixin,
        UserFocusListener,
        UserBlackListener {
  static UserDetailLogic get to => Get.find<UserDetailLogic>();

  ///去除状态栏的头部的高度
  static double headerHeightWithOutStatus = 218.h;

  ///子页面顶部偏移
  static double tabBarTopRadius = 15.h;

  ///是否是自己
  bool isMine = false;

  ///用户id
  late int userId;

  UserDetailRef ref = UserDetailRef.other;

  ///用户信息
  Rx<UserInfo?> targetUserInfo = Rx(null);

  ///是否关注
  var isFocus = false.obs;

  ///tab
  late TabController tabController;
  List<TabModel> tabs = [
    TabModel(id: 0, name: "动态"),
    TabModel(id: 1, name: "照片墙"),
    TabModel(id: 2, name: "礼物墙"),
    //TODO:暂时隐藏
    TabModel(id: 3, name: "限定关系"),
  ];

  @override
  void onInit() {
    super.onInit();
    userId = Get.arguments['id'];
    ref = Get.arguments['ref'];
    if (userId == UserController.to.id) {
      isMine = true;
      targetUserInfo.value = UserController.to.userInfo.value;
    } else {
      isMine = false;
      //判断是否为空（也为了同步上一页面的值）
      targetUserInfo.value = Get.arguments['targetUserInfo'];
      if (targetUserInfo.value == null) {
        _loadTargetUserInfo();
      } else {
        isFocus.value = targetUserInfo.value?.isFocus ?? false;
      }
      _addUserAccess();
      UserController.to.addUserFocusObserver(this);
      UserController.to.addUserBlackObserver(this);
    }
    tabController = TabController(length: tabs.length, vsync: this);
    setSuccessType();
  }

  ///获取他人信息
  _loadTargetUserInfo() {
    setIsLoading = true;
    UserController.to.fetchOtherInfo(userId).then((value) {
      targetUserInfo.value = UserInfo.fromJson(value.data);
      isFocus.value = targetUserInfo.value?.isFocus ?? false;
      setSuccessType();
    }).catchError((e) {
      setErrorType(e);
    });
  }

  ///新增访客记录
  _addUserAccess() {
    request(AppApi.userAddAccessUrl,
        params: {'access_id': userId, 'type': 1}, isShowToast: false);
  }

  ///右上角
  onClickRight() {
    if (isMine) {
      //TODO:后面再做
    } else {
      //TODO:"设置备注", 后面在做
      AppActionSheet().showSheet(
          theme: AppWidgetTheme.dark,
          actions: [
            "举报",
            targetUserInfo.value?.isBlock == 1 ? "移出黑名单" : "拉黑",
            targetUserInfo.value?.isFocus == true ? "取消关注" : "关注"
          ],
          onClick: (index) {
            switch (index) {
              case 0:
                {
                  Get.toNamed(AppRouter().otherPages.reportRoute.name,
                      arguments: {
                        'type': ReportType.user,
                        'id': userId.toString()
                      });
                }
                break;
              case 1:
                UserController.to.onBlackUserOrCancel(targetUserInfo.value);
                break;
              case 2:
                onClickFocus();

                break;
            }
          });
    }
  }

  ///返回
  onClickLeft() {
    Get.back();
  }

  ///进入个人编辑
  onClickPersonEdit() {
    if (isMine) {
      Get.toNamed(AppRouter().otherPages.userEditRoute.name)?.then((value) {
        targetUserInfo.value = UserController.to.userInfo.value;
        setSuccessType();
      });
    }
  }

  ///聊天
  onClickChat() {
    if (ref == UserDetailRef.chatSetting) {
      IMService().pushToMessageDetail(
          userId: userId,
          userName: targetUserInfo.value?.nickname ?? "",
          isOffPush: true);
    } else {
      IMService().pushToMessageDetail(
          userId: userId, userName: targetUserInfo.value?.nickname ?? "");
    }
  }

  ///关注
  onClickFocus() {
    UserController.to.onFocusUserOrCancel(targetUserInfo.value, onUpdate: () {
      //通知刷新
      UserController.to.notifyChangeUserFocus(targetUserInfo.value!);
    });
  }

  ///UserBlackListener
  @override
  onUserBlackChanged(UserInfo userInfo) {
    if (userInfo.id == targetUserInfo.value?.id) {
      targetUserInfo.value?.isBlock = userInfo.isBlock;
    }
  }

  ///UserFocusListener
  @override
  onUserFocusChanged(UserInfo userInfo) {
    if (userInfo.id == targetUserInfo.value?.id) {
      targetUserInfo.value?.meIsFocusUser = userInfo.meIsFocusUser;
      isFocus.value = targetUserInfo.value?.isFocus ?? false;
    }
  }

  @override
  void reLoadData() {
    super.reLoadData();
    _loadTargetUserInfo();
  }

  @override
  void onClose() {
    UserController.to.removeUserBlackObserver(this);
    UserController.to.removeUserFocusObserver(this);
    super.onClose();
  }
}
