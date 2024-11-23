import 'package:youyu/utils/toast_utils.dart';

import 'package:youyu/models/localmodel/item_title_model.dart';
import 'package:youyu/config/api.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/models/room_detail_info.dart';
import 'package:youyu/modules/live/common/notification/live_setting_notify.dart';
import 'package:youyu/modules/live/sub/setting/pop/live_setting_name_pop.dart';
import 'package:youyu/modules/live/sub/setting/pop/live_setting_notice_pop.dart';
import 'package:youyu/modules/live/sub/setting/pop/live_setting_pw_pop.dart';
import 'package:youyu/modules/live/sub/setting/pop/bg/live_setting_room_bg_pop.dart';
import 'package:youyu/modules/live/sub/setting/pop/live_setting_room_type_pop.dart';
import 'package:youyu/modules/live/sub/setting/pop/live_setting_un_lock_pop.dart';
import 'package:youyu/modules/live/sub/setting/pop/live_setting_welcome_pop.dart';
import 'package:youyu/router/router.dart';
import 'package:youyu/services/live/live_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'pop/cover/live_setting_room_cover_pop.dart';

class LiveSettingLogic extends AppBaseController {
  late RoomDetailInfo _roomInfo;
  late LiveSettingNotify _settingNotify;
  late bool _isOwner;

  //名称
  TextEditingController nameController = TextEditingController();

  //公告
  TextEditingController noticeController = TextEditingController();

  //房间类型
  ItemTitleModel roomType = ItemTitleModel(
      type: LiveSettingType.roomType, title: "房间类型", subTitle: "");

  //房间欢迎语
  ItemTitleModel roomWelCome = ItemTitleModel(
      type: LiveSettingType.roomWelcome, title: "房间欢迎语", subTitle: "");

  //是否加锁
  ItemTitleModel roomLock = ItemTitleModel(
      type: LiveSettingType.roomLock, title: "房间加锁", subTitle: "未加锁");

  //列表
  List<ItemTitleModel> list = [];

  @override
  void onInit() {
    super.onInit();

    ///参数
    _roomInfo = Get.arguments['roomInfo'];
    _settingNotify = Get.arguments['settingNotify'];
    _isOwner = Get.arguments['isOwner'];

    ///初始化数据
    nameController.text = _roomInfo.name ?? "";
    roomType.subTitle = _roomInfo.typeName ?? "";
    noticeController.text = _roomInfo.announcement ?? "";
    roomWelCome.subTitle = _roomInfo.welcome ?? "";
    if (_roomInfo.lock == 1) {
      roomLock.subTitle = "已加锁";
      roomLock.extra = true;
    } else {
      roomLock.subTitle = "未加锁";
      roomLock.extra = false;
    }

    ///添加列表
    list.addAll([
      roomType,
      roomLock,
      ItemTitleModel(type: LiveSettingType.roomBg, title: "房间背景", subTitle: ""),
      roomWelCome,
      ItemTitleModel(
          type: LiveSettingType.roomCover, title: "房间封面", subTitle: ""),
    ]);
    if (_isOwner) {
      list.addAll([
        //TODO:先隐藏
        // ItemTitleModel(
        //     type: LiveSettingType.manager, title: "管理员", subTitle: ""),
        ItemTitleModel(type: LiveSettingType.black, title: "黑名单", subTitle: ""),
      ]);
    } else {
      ItemTitleModel(type: LiveSettingType.black, title: "黑名单", subTitle: "");
    }
  }

  ///名称
  showNameDialog() async {
    String? name = await Get.dialog(Center(
      child: LiveSettingNamePop(
        title: "房间名称",
        placeHolder: "请输入20字以内房间名称",
        defaultValue: nameController.text,
      ),
    ));
    if (name?.isNotEmpty == true) {
      bool isSuc =
          await _requestCommit(LiveSettingType.roomName, name: name ?? "");
      if (isSuc) {
        nameController.text = name ?? "";
      }
    }
  }

  ///公告
  showNoticeDialog() async {
    String? name = await Get.dialog(Center(
      child: LiveSettingNoticePop(
        title: "房间公告",
        placeHolder: "请介绍下你的房间玩法与规则，听众了解后可以极参与呦~",
        defaultValue: noticeController.text,
      ),
    ));
    if (name != null) {
      bool isSuc = await _requestCommit(LiveSettingType.roomAnnouncement,
          announcement: name);
      if (isSuc) {
        noticeController.text = name;
      }
    }
  }

  ///房间类型
  showRoomTypeDialog() async {
    //返回的索引列表
    Map<String, dynamic>? typeData = await Get.dialog(Center(
      child: LiveSettingRoomTypePop(
        title: "房间类型",
        defaultData: _roomInfo.typeName != null
            ? {'id': _roomInfo.typeId, 'name': _roomInfo.typeName}
            : null,
      ),
    ));

    if (typeData != null) {
      int typeId = typeData['id'];
      String typeName = typeData['name'];
      bool isSuc = await _requestCommit(LiveSettingType.roomType, type: typeId);
      if (isSuc) {
        roomType.subTitle = typeName;
      }
    }
    setSuccessType();
  }

  ///欢迎语
  showWelComeDialog() async {
    String? name = await Get.dialog(Center(
      child: LiveSettingWelComePop(
        title: "房间欢迎语",
        placeHolder: "请输入房间欢迎语",
        defaultValue: roomWelCome.subTitle ?? "",
      ),
    ));
    if (name != null) {
      bool isSuc =
          await _requestCommit(LiveSettingType.roomWelcome, welcome: name);
      if (isSuc) {
        roomWelCome.subTitle = name;
        setSuccessType();
      }
    }
  }

  ///房间背景
  showLiveRoomBg() async {
    bool? isSuc = await Get.dialog(Center(
      child: LiveSettingRoomBgPop(
        title: '房间背景',
        curUrl: _roomInfo.background?.url,
        roomId: _roomInfo.id,
      ),
    ));
    if (isSuc == true) {
      _notify(LiveSettingType.roomBg);
    }
  }

  ///加锁
  showLockDialog() async {
    if (roomLock.extra != null && (roomLock.extra as bool) == true) {
      bool? isLock = await Get.dialog(const Center(
        child: LiveSettingUnLockDialog(
          title: '房间解锁',
          msg: '是否解锁房间？',
        ),
      ));
      if (isLock != null && isLock) {
        bool isSuc = await _requestCommit(
          LiveSettingType.roomLock,
          lock: 0,
        );
        if (isSuc) {
          roomLock.subTitle = "未加锁";
          roomLock.extra = false;
          ToastUtils.show("解锁成功");
          setSuccessType();
        }
      }
    } else {
      String? lock = await Get.dialog(const Center(
        child: LiveSettingPwPop(
          title: "密码锁房",
          placeHolder: "建议设置6位数以上包含数字和字母...",
        ),
      ));
      if (lock?.isNotEmpty == true) {
        bool isSuc = await _requestCommit(LiveSettingType.roomLock,
            lock: 1, password: lock);
        if (isSuc) {
          roomLock.subTitle = "已加锁";
          roomLock.extra = true;
          ToastUtils.show("加锁成功");
          setSuccessType();
        }
      }
    }
  }

  ///房间封面
  showLiveRoomCover() async {
    bool? isSuc = await Get.dialog(Center(
      child: LiveSettingRoomCoverPop(
        title: '房间封面',
        avatar: _roomInfo.avatar ?? "",
      ),
    ));
    if (isSuc == true) {
      _notify(LiveSettingType.roomBg);
    }
  }

  onClickItem(ItemTitleModel model) {
    switch (model.type as LiveSettingType) {
      case LiveSettingType.roomType:
        showRoomTypeDialog();
        break;
      case LiveSettingType.roomLock:
        showLockDialog();
        break;
      case LiveSettingType.roomBg:
        showLiveRoomBg();
        break;
      case LiveSettingType.roomWelcome:
        showWelComeDialog();
        break;
      case LiveSettingType.roomCover:
        showLiveRoomCover();
        break;
      case LiveSettingType.manager:
        Get.toNamed(AppRouter().livePages.liveSettingMangerRoute.name,
            arguments: {
              'roomId': _roomInfo.id,
              'settingNotify': _settingNotify
            });
        break;
      case LiveSettingType.black:
        Get.toNamed(AppRouter().livePages.liveSettingBlackRoute.name,
            arguments: {
              'roomId': _roomInfo.id,
              'settingNotify': _settingNotify
            });
        break;
      default:
        break;
    }
  }

  ///提交
  _requestCommit(LiveSettingType settingType,
      {int? avatar,
      String? name,
      int? type,
      int? lock,
      String? password,
      String? announcement,
      String? welcome,
      int? background}) async {
    showCommit();
    Map<String, dynamic> params = {};
    if (avatar != null) {
      params['avatar'] = avatar;
    }
    if (name != null) {
      params['name'] = name;
    }
    if (type != null) {
      params['type'] = type;
    }
    if (lock != null) {
      params['lock'] = lock;
    }
    if (password != null) {
      params['password'] = password;
    }
    if (announcement != null) {
      params['announcement'] = announcement;
    }
    if (welcome != null) {
      params['welcome'] = welcome;
    }
    if (background != null) {
      params['background'] = background;
    }
    try {
      await request(AppApi.roomEditUrl, params: params);
      ToastUtils.show("修改成功");
      _notify(settingType);
      return true;
    } catch (e) {
      hiddenCommit();
    }
    return false;
  }

  _notify(LiveSettingType settingType) async {
    var value = await request(AppApi.liveInfoUrl,
        params: {"room_id": _roomInfo.id}, isPrintLog: true);
    RoomDetailInfo info = RoomDetailInfo.fromJson(value.data);
    _roomInfo = info;
    _settingNotify.roomSettingNotify(settingType, info);
  }
}
