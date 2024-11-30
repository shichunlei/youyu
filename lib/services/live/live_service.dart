import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/services/http/http_response.dart';
import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/widgets/create/live_create_dialog.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/room_init.dart';
import 'package:youyu/router/router.dart';
import 'package:youyu/services/permission_service.dart';
import 'package:youyu/services/trtc/trtc_service.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../models/room_detail_info.dart';
import 'widget/live_pass_word_pop.dart';

///直播间背景类型
enum LiveBackGroundType { none, image, svg }

///直播公屏遮罩类型
enum LiveScreenMaskType {
  normal(type: 0),
  short(type: 1),
  middle(type: 2),
  long(type: 3);

  const LiveScreenMaskType({required this.type});

  final int type;

  factory LiveScreenMaskType.fromType(int type) {
    return values.firstWhere((e) => e.type == type);
  }
}

///直播间设置类型
enum LiveSettingType {
  roomName(type: 0), //直播间名称
  roomAnnouncement(type: 1), //直播间公告
  roomType(type: 2), //直播分类
  roomLock(type: 3), //直播加锁/解锁
  roomBg(type: 4), //直播背景
  roomWelcome(type: 5), //直播欢迎语
  roomCover(type: 6), //直播封面

  manager(type: 7), //管理员设置
  black(type: 8); //黑名单设置

  const LiveSettingType({required this.type});

  final int type;

  factory LiveSettingType.fromType(int type) {
    return values.firstWhere((e) => e.type == type);
  }
}

///直播服务
class LiveService extends AppBaseController {
  static LiveService? _instance;

  factory LiveService() => _instance ??= LiveService._();

  LiveService._();

  ///配置
  //是否打开公屏的tab
  bool isOpenScreenTab = true;

  //是否开启小窗口
  var isShowGlobalCard = false.obs;

  //是否在直播间内
  var isInLive = false;

  ///直播分类
  List<TabModel> liveClassList = [];
  List<String> liveClassNameList = [];

  ///游戏相关
  //转盘动画
  var isWheelGameAniOpen = true.obs;

  ///获取分类列表
  fetchLiveClsList() async {
    if (liveClassNameList.isEmpty) {
      try {
        var value = await request(AppApi.liveSubClsUrl);
        var list = (value.data as List<dynamic>)
            .map((e) => TabModel.fromJson(e))
            .toList();
        liveClassList.addAll(list);
        liveClassNameList.addAll(list.map((e) => e.name).toList());
      } catch (e) {
        rethrow;
      }
    }
  }

  ///进入直播间
  ///roomId 直播间id
  ///imGroupId im群组id
  pushToLive(int? roomId, String? imGroupId,
      {bool isMyRoom = false, bool isChangeRoom = false}) async {
    if (UserController.to.userInfo.value == null) {
      UserController.to.updateMyInfo();
    }
    //1.判断权限
    PermissionStatus status =
        await PermissionService().checkMicrophonePermission();
    if (status == PermissionStatus.granted) {
      //2.是否是自己房间
      if (isMyRoom) {
        if (LiveService().isShowGlobalCard.value &&
            TRTCService().currentRoomInfo.value?.id != roomId) {
          if (TRTCService().currentRoomInfo.value != null) {
            await TRTCService().leaveRoom();
          }
        }
        _enterLive(roomId, imGroupId, isChangeRoom);
      } else {
        if (LiveService().isShowGlobalCard.value &&
            TRTCService().currentRoomInfo.value?.id == roomId) {
          _enterLive(roomId, imGroupId, isChangeRoom);
        } else {
          //3.校验房间
          if (TRTCService().currentRoomInfo.value != null) {
            await TRTCService().leaveRoom();
          }
          RoomInit? roomInit = await _checkLockAndBlack(roomId);
          if (roomInit != null) {
            if (roomInit.isBlack == 1) {
              hiddenCommit();
              ToastUtils.show("你被加入了黑名单");
              return false;
            }
            //4.校验密码
            if (roomInit.lock == 1) {
              _showPasswordLive(roomId, imGroupId, isChangeRoom);
            } else {
              _enterLive(roomId, imGroupId, isChangeRoom);
            }
          }
        }
      }
    }
  }

  ///校验房间
  Future<RoomInit?> _checkLockAndBlack(int? roomId) async {
    showCommit();
    try {
      var value = await request(AppApi.liveJoinRoomUrl,
          isHiddenCommitLoading: false, params: {'room_id': roomId});

      // LiveIndexLogic.to.liveWorldMsgObs.value = value.data['world_message'];
      return RoomInit.fromJson(value.data);
    } catch (e) {
      hiddenCommit();
    }
    return null;
  }

  ///密码弹窗
  _showPasswordLive(int? roomId, String? imGroupId, bool isChangeRoom) async {
    hiddenCommit();
    Get.dialog(
      LivePwPop(
        roomId: roomId ?? 0,
        onClickLock: (int roomId, String pw) async {
          _requestCheckPw(roomId, pw, imGroupId, isChangeRoom);
        },
      ),
      barrierDismissible: false,
    );
  }

  ///校验密码
  _requestCheckPw(
      int roomId, String pw, String? imGroupId, bool isChangeRoom) async {
    showCommit();
    try {
      HttpResponse value = await request(AppApi.liveUnlockPwUrl,
          params: {
            'room_id': roomId,
            'password': pw,
          },
          isHiddenCommitLoading: false);
      if (value.code == 1) {
        _enterLive(roomId, imGroupId, isChangeRoom);
      } else {
        ToastUtils.show("密码错误");
      }
    } catch (e) {
      hiddenCommit();
    }
  }

  ///进入自己的房间
  pushToMyLive() async {
    if (UserController.to.userInfo.value!.thisRoom == 1) {
      //创建房间直接进入
      pushToLive(UserController.to.userInfo.value?.thisRoomInfo?.id ?? 0,
          UserController.to.userInfo.value?.thisRoomInfo?.groupId ?? "",
          isMyRoom: true);
    } else {
      ///没有进行创建
      try {
        Map<String, dynamic>? result =
            await Get.bottomSheet(const LiveCreateDialog());
        if (result != null) {
          String name = result['name'];
          int typeId = result['type_id'];
          try {
            showCommit();
            var value = await request(AppApi.liveCreateUrl,
                isHiddenCommitLoading: false,
                params: {'name': name, 'type_id': typeId});
            //刷新信息
            UserController.to.updateMyInfo();
            await 0.5.delay();
            pushToLive(value.data['id'], value.data['group_id'],
                isMyRoom: true);
          } catch (e) {
            hiddenCommit();
            e.printError();
          }
        }
      } catch (e) {
        ToastUtils.show("创建失败");
      }
    }
  }

  _enterLive(int? roomId, String? groupId, bool isChangeRoom) async {
    //判断关闭小窗口
    if (LiveService().isShowGlobalCard.value) {
      LiveService().isShowGlobalCard.value = false;
    }
    if (TRTCService().currentRoomInfo.value?.id == roomId) {
      //直接进入
      _finallyEnterRoom(false, roomId, groupId,
          TRTCService().currentRoomInfo.value, true, false);
    } else {
      Future.delayed(const Duration(milliseconds: 100), () {
        _requestRoomInfo(roomId, groupId, isChangeRoom);
      });
    }
  }

  _requestRoomInfo(int? roomId, String? groupId, bool isChangeRoom) {
    ///前置获取房间信息
    request(AppApi.liveInfoUrl, params: {"room_id": roomId}, isPrintLog: true)
        .then((value) async {
      RoomDetailInfo roomInfo = RoomDetailInfo.fromJson(value.data);
      if (isChangeRoom) {
        _finallyEnterRoom(
            isChangeRoom, roomId, groupId, roomInfo, false, false);
      } else {
        _finallyEnterRoom(isChangeRoom, roomId, groupId, roomInfo, false, true);
      }
    });
  }

  ///最终进入
  _finallyEnterRoom(bool isChangeRoom, int? roomId, String? groupId,
      RoomDetailInfo? roomInfo, bool isFloatEnter, bool preventDuplicates) {
    if (isChangeRoom) {
      Get.offNamed(AppRouter().livePages.liveIndexRoute.name,
          arguments: {
            'roomId': roomId,
            'groupId': groupId,
            'roomInfo': roomInfo,
            'isFloatEnter': isFloatEnter
          },
          preventDuplicates: preventDuplicates);
    } else {
      Get.toNamed(AppRouter().livePages.liveIndexRoute.name,
          arguments: {
            'roomId': roomId,
            'groupId': groupId,
            'roomInfo': roomInfo,
            'isFloatEnter': isFloatEnter
          },
          preventDuplicates: preventDuplicates);
    }
  }
}
