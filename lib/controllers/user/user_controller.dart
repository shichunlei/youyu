import 'package:youyu/utils/log_utils.dart';
import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/app_controller.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/sub/user_children_control.dart';
import 'package:youyu/controllers/user/sub/user_level_control.dart';
import 'package:youyu/controllers/user/sub/user_nobility_control.dart';
import 'package:youyu/controllers/user/sub/user_set_control.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/router/router.dart';
import 'package:youyu/widgets/app/dialog/app_tip_dialog.dart';
import 'package:get/get.dart';

///用户主页来源
enum UserDetailRef {
  chatSetting, //聊天设置页面
  live, //直播页面
  other //其他页面
}

///关注监听
mixin UserFocusListener {
  onUserFocusChanged(UserInfo userInfo);
}

///拉黑监听
mixin UserBlackListener {
  onUserBlackChanged(UserInfo userInfo);
}

///用户信息管理
class UserController extends AppBaseController {
  static UserController get to => Get.find<UserController>();

  Rx<UserInfo?> userInfo = Rx(null);

  ///常用用户数据数据
  //手机号
  String get mobile => userInfo.value?.mobile ?? "";

  //加密手机号
  String get encryptMobile {
    if (mobile.length >= 11) {
      return mobile.replaceRange(3, 7, '***');
    }
    return mobile;
  }

  //昵称
  String get nickname => userInfo.value?.nickname ?? "";

  //用户ID
  int get id => userInfo.value?.id ?? 0;

  //靓号（页面显示id的地方都用这个）
  int get fancyNumber => userInfo.value?.fancyNumber ?? 0;

  //是否显示靓号高亮
  bool get isHighFancyNum => ((userInfo.value?.isFancyNumber ?? 0) == 1);

  //im user sig
  String get imUserSig => userInfo.value?.imUserSig ?? "";

  //0:未知 1:男 2:女
  int get gender => userInfo.value?.gender ?? 0;

  //头像
  String get avatar =>
      userInfo.value?.avatar ?? AppController.to.userDefaultAvatar;

  //金币余额 (茶豆)
  num get coins => userInfo.value?.coins ?? 0;

  //钻石余额
  num get diamonds => userInfo.value?.diamonds ?? 0;

  //vip
  bool get isVip => (userInfo.value?.isVip ?? false);

  bool get isSVip => (userInfo.value?.isSVip ?? false);

  //是否设置密码
  int get isSetPw => userInfo.value?.isPass ?? 0;

  //青少年模式管理
  UserChildrenControl childrenControl = UserChildrenControl();

  //等级管理
  UserLevelControl levelControl = UserLevelControl();

  //爵位管理
  UserNobilityControl nobilityControl = UserNobilityControl();

  //设置管理
  UserSetControl setControl = UserSetControl();

  ///更新用户信息
  updateMyInfo() async {
    try {
      //请求更新
      var userValue = await request(AppApi.userInfoUrl, isPrintLog: true);
      userInfo.value = UserInfo.fromJson(userValue.data);
      //子管理器更新
      childrenControl.onUpdateUserInfo();
      levelControl.onUpdateUserInfo();
      nobilityControl.onUpdateUserInfo();
    } catch (e) {
      LogUtils.onError(e);
    }
  }

  /// 获取他人信息
  fetchOtherInfo(int? targetUserId, {int? roomId}) async {
    return request(AppApi.otherUserInfoUrl,
        params: {"user_id": targetUserId, 'room_id': roomId}, isPrintLog: true);
  }

  ///获取用户关系
  fetchUserRelation(int? targetUserId) async {
    return request(AppApi.userRelationUrl,
        params: {"user_id": targetUserId}, isPrintLog: true);
  }

  ///关注/取消关注好友
  //关注监听
  final List<UserFocusListener> _userFocusObservers = [];

  //监听
  addUserFocusObserver(UserFocusListener listener) {
    _userFocusObservers.add(listener);
  }

  removeUserFocusObserver(UserFocusListener listener) {
    _userFocusObservers.remove(listener);
  }

  //通知刷新
  notifyChangeUserFocus(UserInfo? userInfo) {
    if (userInfo != null) {
      for (UserFocusListener listener in _userFocusObservers) {
        listener.onUserFocusChanged(userInfo);
      }
    }
  }

  //关注/取消关注
  onFocusUserOrCancel(UserInfo? model, {Function? onUpdate}) {
    showCommit();
    if (model != null) {
      if (model.isFocus) {
        request(AppApi.userCancelFocusUrl, params: {'focus_id': model.id})
            .then((value) {
          model.meIsFocusUser = 0;
          ToastUtils.show(value.msg);
          if (onUpdate != null) {
            onUpdate();
          }
        });
      } else {
        request(AppApi.userFocusUrl, params: {'focus_id': model.id})
            .then((value) {
          model.meIsFocusUser = 1;
          ToastUtils.show(value.msg);
          if (onUpdate != null) {
            onUpdate();
          }
        });
      }
    }
  }

  ///拉黑用户
  //拉黑监听
  final List<UserBlackListener> _userBlackObservers = [];

  //监听
  addUserBlackObserver(UserBlackListener listener) {
    _userBlackObservers.add(listener);
  }

  removeUserBlackObserver(UserBlackListener listener) {
    _userFocusObservers.remove(listener);
  }

  //通知刷新
  notifyChangeBlackFocus(UserInfo userInfo) {
    for (UserBlackListener listener in _userBlackObservers) {
      listener.onUserBlackChanged(userInfo);
    }
  }

  onBlackUserOrCancel(UserInfo? userInfo) {
    if (userInfo == null) return;
    if (userInfo.isBlock == 1) {
      showCommit();
      _requestBlack(userInfo);
    } else {
      AppTipDialog().showTipDialog("提示", AppWidgetTheme.dark, msg: "确定拉黑该用户",
          onCommit: () {
        showCommit();
        _requestBlack(userInfo);
      });
    }
  }

  _requestBlack(UserInfo? userInfo) {
    request(AppApi.userBlackUrl, params: {"user_id": userInfo!.id!})
        .then((value) {
      if (value.data['is_block'] == 1) {
        userInfo.isBlock = 1;
        ToastUtils.show("拉黑成功");
      } else {
        userInfo.isBlock = 0;
        ToastUtils.show("移出成功");
      }
      notifyChangeBlackFocus(userInfo);
    });
  }

  ///进入用户主页
  pushToUserDetail(int? userId, UserDetailRef ref, {UserInfo? targetUserInfo}) {
    Get.toNamed(AppRouter().otherPages.userDetailRoute.name,
        preventDuplicates: false,
        arguments: {
          'id': userId,
          'ref': ref,
          'targetUserInfo': targetUserInfo
        });
  }

  //im的用户信息
  static UserInfo imUserInfo() {
    return UserInfo(
        id: UserController.to.id,
        fancyNumber: UserController.to.fancyNumber,
        isFancyNumber: UserController.to.isHighFancyNum ? 1 : 0,
        nickname: UserController.to.nickname,
        avatar: UserController.to.avatar,
        gender: UserController.to.gender,
        userVal: UserController.to.userInfo.value?.userVal,
        dress: UserController.to.userInfo.value?.dress);
  }

  /// 清空用户信息
  clearMyUserInfo() {
    userInfo.value = null;
    childrenControl.onClearUserInfo();
    levelControl.onClearUserInfo();
    nobilityControl.onClearUserInfo();
  }
}
