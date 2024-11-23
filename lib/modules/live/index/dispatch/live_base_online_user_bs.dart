import 'dart:async';
import 'package:youyu/modules/live/index/live_index_logic.dart';
import 'package:youyu/utils/log_utils.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/auth_controller.dart';
import 'package:youyu/models/my_getuserinfo.dart';

///在线用户
mixin LiveBaseOnlineUserBsListener {
  //定时刷新
  onOnlineUserUpdateTimerStart();

  //强制刷新
  onOnlineUserForceUpdate();
}

///在线用户业务
class LiveBaseOnlineUserBs with LiveBaseOnlineUserBsListener {
  Timer? _timer;
  var lastGetTime = 0;

  @override
  onOnlineUserUpdateTimerStart() {
    //获取在线用户列表
    fetchOnlineUser();

    //取消定时获取top3
    //改为在线用户列表取top3
    //获取top3用户
    // fetchTop3User();
    _timer = Timer.periodic(const Duration(seconds: 20), (timer) async {
      if (!AuthController.to.isLogin) {
        timer.cancel();
        return;
      }
      int nowGetTime = DateTime.now().millisecondsSinceEpoch;
      if (lastGetTime > 0) {
        LogUtils.onPrint('距离上次更新时隔 ${(nowGetTime - lastGetTime) / 1000}');
      }
      lastGetTime = nowGetTime;
      LogUtils.onPrint('更新了在线列表 20s');
      try {
        fetchOnlineUser();
        // fetchTop3User();
      } catch (e) {
        LogUtils.onError(e);
      }
    });
  }

  @override
  onOnlineUserForceUpdate() {
    //获取在线用户列表
    fetchOnlineUser();
    //获取top3用户
    // fetchTop3User();
  }

  ///获取top3用户
  fetchTop3User() {
    // LiveIndexLogic.to
    //     .request(AppApi.liveTop3Url,
    //         params: {"room_id": LiveIndexLogic.to.roomId},
    //         isShowToast: false,
    //         isPrintLog: false)
    //     .then((value) {
    //   List<dynamic> list = (value.data as List<dynamic>);
    //   LiveIndexLogic.to.viewObs.top3UserList.value =
    //       list.map((e) => UserInfo.fromJson(e)).toList();
    // });

    List<UserInfo> top3Users =
        LiveIndexLogic.to.viewObs.onlineUserList.take(3).toList();
    LiveIndexLogic.to.viewObs.top3UserList.value = top3Users;
  }

  ///获取在线用户列表
  fetchOnlineUser() {
    LiveIndexLogic.to
        .request(AppApi.liveOnlineUrl,
            params: {"room_id": LiveIndexLogic.to.roomId},
            isShowToast: false,
            isPrintLog: false)
        .then((value) {
      List<dynamic> list = (value.data as List<dynamic>);
      LiveIndexLogic.to.viewObs.onlineUserList.value =
          list.map((e) => UserInfo.fromJson(e)).toList();

      List<UserInfo> top3Users =
          LiveIndexLogic.to.viewObs.onlineUserList.take(3).toList();
      LiveIndexLogic.to.viewObs.top3UserList.value = top3Users;
    });
  }

  onClose() {
    _timer?.cancel();
  }
}
