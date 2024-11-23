import 'package:youyu/utils/sp_utils.dart';
import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/controllers/app_controller.dart';
import 'package:youyu/controllers/conversation_controller.dart';
import 'package:youyu/controllers/gift_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/router/router.dart';
import 'package:youyu/services/im/im_error.dart';
import 'package:youyu/services/im/im_service.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:youyu/services/trtc/trtc_service.dart';
import 'package:youyu/services/voice_service.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_callback.dart';
import '../services/socket/socket_service.dart';
import 'base/base_controller.dart';
import 'package:youyu/config/api.dart';

//验证码类型 (类型1:注册账号/验证码登录 2:找回密码 3:修改手机号)
enum SmsType {
  registerLogin("1"),
  findPw("2"),
  changePhone("3"),
  changePw("4");

  const SmsType(this.type);

  final String type;
}

///app认证(登录)管理
class AuthController extends AppBaseController {
  static AuthController get to => Get.find<AuthController>();

  final String _tokenKey = 'm_token';
  final String _idKey = 'm_id';

  ///登录
  bool _isLogin = false;

  bool get isLogin => _isLogin;

  ///token
  String _token = "";

  String get token => _token;

  ///id (暂时没用到)
  String _id = "";

  String get id => _id;

  @override
  void onInit() async {
    super.onInit();
    _token = await StorageUtils.getValue(_tokenKey, "");
    _id = await StorageUtils.getValue(_idKey, "");
    if (_token.isNotEmpty) {
      _isLogin = true;
    } else {
      _isLogin = false;
    }
  }

  ///1.账号登录
  accountLogin({required String account, required String pw}) async {
    showCommit();
    try {
      var value = await request(AppApi.loginUrl,
          isHiddenCommitLoading: false,
          params: {
            "mobile": account,
            "password": pw,
          });
      _setLoginData(value.data);
    } catch (e) {
      hiddenCommit();
    }
  }

  ///2.验证码登录
  quickLogin({required String mobile, required String code}) async {
    showCommit();
    try {
      var value = await request(AppApi.quickLoginUrl,
          isHiddenCommitLoading: false,
          params: {
            "mobile": mobile,
            "code": code,
          });
      _setLoginData(value.data);
    } catch (e) {
      hiddenCommit();
    }
  }

  ///3.一键登录
  oneKeyLogin({required String accessToken}) async {
    showCommit();
    try {
      var value = await request(AppApi.onKeyLoginUrl,
          isHiddenCommitLoading: false,
          params: {
            "access_token": accessToken,
          });
      _setLoginData(value.data);
    } catch (e) {
      hiddenCommit();
    }
  }

  ///4.完成信息后登录
  ///avatar 头像id
  ///birth_time 10位时间戳
  ///gender 性别 0:未知 1:男 2:女
  registerInfoLogin(
      {required String mobile,
      required String code,
      required String avatar,
      required String nickname,
      required String gender,
      required String birthTime}) async {
    try {
      var value = await request(AppApi.perfectUserInfoUrl, params: {
        "mobile": mobile,
        "code": code,
        "avatar": avatar,
        "nickname": nickname,
        "gender": gender,
        "birth_time": birthTime
      });
      _setLoginData(value.data);
    } catch (e) {
      hiddenCommit();
    }
  }

  ///5.自动登录
  autoLogin() async {
    try {
      //1.设置用户信息
      await UserController.to.updateMyInfo();
      //2.登录im
      V2TimCallback res = await IMService().login(
          '${AppController.to.tencentUserPrefix}_${UserController.to.id}',
          UserController.to.imUserSig);
      //TODO:test
      res.code = 0;
      if (res.code == 0) {
        //3.设置im信息
        await IMService().setUserInfo(
          nickName: UserController.to.nickname,
          faceUrl: UserController.to.avatar,
          userID: UserController.to.id.toString(),
        );
        //4.请求背包礼物
        GiftController.to.fetchBackPack(foreUpdate: true);
        //5.连接ws
        if (SocketService().socketConnectStatus !=
            SocketConnectStatus.socketStatusConnected) {
          SocketService().onInit();
        }
      } else {
        throw IMErrorException();
      }
    } catch (e) {
      rethrow;
    }
  }

  //设置登录数据
  _setLoginData(dynamic data) async {
    //1.保存登录信息
    _token = data['token'];
    await StorageUtils.setValue(_tokenKey, _token);
    _id = data['id'].toString();
    await StorageUtils.setValue(_idKey, _id);
    _isLogin = true;
    try {
      //2.设置用户信息
      await UserController.to.updateMyInfo();
      //3.登录im
      V2TimCallback res = await IMService().login(
          '${AppController.to.tencentUserPrefix}_${UserController.to.id}',
          UserController.to.imUserSig);
      //TODO:test
      res.code = 0;
      if (res.code == 0) {
        //4.设置im信息
        await IMService().setUserInfo(
          nickName: UserController.to.nickname,
          faceUrl: UserController.to.avatar,
          userID: UserController.to.id.toString(),
        );
        //5.同步通知未读
        AppController.to.requestSysNoticeUnReadCount();
        //6.请求背包礼物
        GiftController.to.fetchBackPack(foreUpdate: true);
        //7.连接ws
        if (SocketService().socketConnectStatus !=
            SocketConnectStatus.socketStatusConnected) {
          SocketService().onInit();
        }
        //8.登录成功
        ToastUtils.show("登录成功");
        Get.offAllNamed(AppRouter().indexRoute.name);
      } else {
        hiddenCommit();
        throw IMErrorException();
      }
    } catch (e) {
      _removeLoginData();
      if (e is IMErrorException) {
        ToastUtils.show("聊天服务登录失败，请重试");
      } else {
        ToastUtils.show("登录失败，请重试");
      }
    }
    hiddenCommit();
  }

  ///退出登录
  ///(1) 主动退出
  ///(2) 鉴权失败
  ///(3) im token失效
  ///(4) 注销
  ///initiative 是否主动退出
  logout({required bool initiative}) async {
    //0关闭小窗口
    if (LiveService().isShowGlobalCard.value) {
      LiveService().isShowGlobalCard.value = false;
    }

    ///是否service
    //1.关闭直播
    if (TRTCService().currentRoomInfo.value != null) {
      await TRTCService().leaveRoom();
    }
    //2.关闭ws
    SocketService().closeSocket(isLogoutMethod: true);
    //3.im退出登录
    await IMService().logOut();
    //4.停止播放所有音频
    await VoiceService().stopAudio();

    ///移除全局控制器
    //1.移除登录数据
    await _removeLoginData();
    //2.移除用信息
    UserController.to.clearMyUserInfo();
    //3.移除全局变量
    AppController.to.resetByLoginOut();
    //4.移除会话数据
    ConversationController.to.resetByLoginOut();
    //3.跳转到登录
    Get.offAllNamed(AppRouter().loginPages.loginIndexRoute.name);
  }

  ///移除登录数据
  _removeLoginData() async {
    _token = "";
    _id = "";
    _isLogin = false;
    await StorageUtils.remove(_tokenKey);
    await StorageUtils.remove(_idKey);
  }
}
