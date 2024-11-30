import 'package:youyu/config/config.dart';
import 'package:youyu/utils/toast_utils.dart';
import 'package:youyu/models/localmodel/tab_model.dart';
import 'package:youyu/widgets/gift/sheet/common_gift_custom_count.dart';
import 'package:youyu/controllers/gift_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/gift.dart';
import 'package:youyu/models/gift_tab.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:flutter/material.dart';
import '../../../controllers/base/base_controller.dart';
import 'model/common_gift_pop_model.dart';
import 'package:get/get.dart';

import 'sheet/common_gift_count_sheet.dart';

class CommonGiftPopLogic extends AppBaseController {
  ///update id
  static int userListId = 1;

  ///参数
  //房间id （直播间使用）
  int? roomId;

  //是否显示用户列表
  bool isShowUserList = false;

  //是否是麦位用户
  bool isSeatUsers = false;

  //用户总列表
  List<GiftUserPositionInfo> giftUserList = [];

  //用户id （会话使用）
  UserInfo? receiver;

  ///用户相关
  // 选择的人
  List<int> selectedUsers = <int>[];

  // 是否全选用户
  bool isSelectedAllUser = false;

  //选择用户
  onSelectedUser(int userId) {
    if (!isSeatUsers) return;

    //改成单选
    selectedUsers.clear();

    List<int> list = List.from(selectedUsers);
    if (selectedUsers.contains(userId)) {
      list.remove(userId);
    } else {
      list.add(userId);
    }
    selectedUsers = list;
    //判断全选
    if (selectedUsers.length == giftUserList.length) {
      isSelectedAllUser = true;
    } else {
      isSelectedAllUser = false;
    }

    update([userListId]);
  }

  ///数量相关
  List<CommonGiftCountModel> countList = [
    CommonGiftCountModel(name: "一心一意", count: 1),
    CommonGiftCountModel(name: "十全十美", count: 10),
    CommonGiftCountModel(name: "一切顺利", count: 66),
    CommonGiftCountModel(name: "长长久久", count: 99),
    CommonGiftCountModel(name: "要抱抱", count: 188),
    CommonGiftCountModel(name: "我爱你", count: 520),
    CommonGiftCountModel(name: "一生一世", count: 1314),
  ];

  List<CommonGiftCountModel> luckyCountList = [
    CommonGiftCountModel(name: "一心一意", count: 1),
    CommonGiftCountModel(name: "十全十美", count: 10),
    CommonGiftCountModel(name: "一切顺利", count: 30),
  ];

  // 要赠送礼物的数量
  var giftCount = 1.obs;

  //自定义数量
  final TextEditingController _controller = TextEditingController();

  //显示数量弹窗
  showCountSheet() async {
    int? count = await Get.dialog(
        CommonGiftCountSheet(
          list: _giftTypeId == GiftController.ftId ? luckyCountList : countList,
          onCustomCount: _showCustomCount,
        ),
        barrierColor: Colors.transparent);
    giftCount.value = count ?? 1;
  }

  //自定义数量弹窗
  _showCustomCount() async {
    int? count = await Get.bottomSheet(
        CommonGiftCustomCount(
          textController: _controller,
          maxValue: _giftTypeId == GiftController.ftId ? 30 : null,
        ),
        isScrollControlled: true);
    giftCount.value = count ?? 1;
  }

  ///礼物相关
  //tab
  List<TabModel<List<Gift>>> tabs = [];

  //当前选择礼物
  Gift? _curGift;

  //当前选择的礼物类型id,背包礼物id为-99
  int _giftTypeId = 0;

  fetchGiftList() {
    if (isShowUserList && !isSeatUsers) {
      selectedUsers.add(giftUserList.first.user.id ?? 0);
    }

    for (int i = 0; i < GiftController.to.giftList.length; i++) {
      GiftTab element = GiftController.to.giftList[i];
      tabs.add(TabModel(
          id: element.id, name: element.name, customExtra: element.giftList));
    }

    ///单独加背包
    tabs.add(TabModel(name: "背包", id: GiftController.backPackId));
    if (tabs.isNotEmpty) {
      _giftTypeId = tabs.first.id;
    }
    //异步更新用户信息
    UserController.to.updateMyInfo();
  }

  ///更改选中的礼物类型，然后默认此类型的第一个礼物
  updateGiftType(int index) {
    _giftTypeId = tabs[index].id;
    updateGiftInfo(tabs[index].customExtra?.first, _giftTypeId);
    giftCount.value = 1;
  }

  ///更改选中的礼物
  updateGiftInfo(Gift? gift, int giftTypeId) {
    _curGift = gift;
    _giftTypeId = giftTypeId;
    if (gift?.id == AppConfig.gameWheelId) {
      if (isShowUserList && selectedUsers.isEmpty) {
        //TODO:test
        // ToastUtils.show("请选择用户");
        // return;
      }
      CommonGiftSendModel sendModel = CommonGiftSendModel(
          gift: _curGift!,
          giftCount: giftCount.value,
          giftTypeId: _giftTypeId,
          roomId: roomId,
          receiver: receiver);
       return sendModel;
    }
    return null;
  }

  ///赠送礼物
  onSendGift() async {
    if (_curGift != null) {
      if (isShowUserList && selectedUsers.isEmpty) {
        ToastUtils.show("请选择用户");
        return;
      }
      CommonGiftSendModel sendModel = CommonGiftSendModel(
          gift: _curGift!,
          giftCount: giftCount.value,
          giftTypeId: _giftTypeId,
          roomId: roomId,
          receiver: receiver);
      //选择的用户
      sendModel.selUserPosInfo = [];
      for (var userId in selectedUsers) {
        GiftUserPositionInfo userInfo =
        giftUserList.firstWhere((element) => element.user.id == userId);
        sendModel.selUserPosInfo?.add(userInfo);
      }
      return sendModel;
    } else {
      ToastUtils.show("请选择礼物");
      return null;
    }
  }
}
