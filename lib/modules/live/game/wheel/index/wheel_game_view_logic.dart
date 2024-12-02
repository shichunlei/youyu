import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/models/gift.dart';
import 'package:youyu/modules/live/common/notification/send/live_index_send_msg.dart';
import 'package:youyu/modules/live/game/wheel/result/wheel_game_result_dialog.dart';
import 'package:youyu/modules/live/game/wheel/rule/wheel_game_rule_dialog.dart';
import 'package:youyu/router/router.dart';
import 'package:youyu/services/game/game_service.dart';
import 'package:youyu/services/im/model/ext/im_gift_model.dart';
import 'package:youyu/services/im/model/im_custom_message_mdoel.dart';
import 'package:youyu/widgets/gift/model/common_gift_pop_model.dart';
import 'widget/wheel_turn_widget.dart';

class WheelGameViewLogic extends AppBaseController {
  //类型
  Rx<GameSubViewType> viewType = Rx(GameSubViewType.primary);
  bool isOpenTurn = false;
  late CommonGiftSendModel sendModel;
  late LiveIndexSendMsg sendMsg;

  //礼物列表
  List<Gift>? tempList;

  //转盘
  final GlobalKey<WheelTurnWidgetState> turnKey =
      GlobalKey<WheelTurnWidgetState>();

  @override
  void onReady() {
    super.onReady();
    onChangeType(GameSubViewType.primary);
  }

  ///更改类型
  onChangeType(GameSubViewType type) async {
    if (isOpenTurn) return;
    switch (type) {
      case GameSubViewType.primary:
        if (GameService().primaryImages.isEmpty) {
          showCommit();
          await GameService().loadListData(type);
        }
        break;
      case GameSubViewType.advanced:
        if (GameService().advancedImages.isEmpty) {
          showCommit();
          await GameService().loadListData(type);
        }
        break;
    }
    hiddenCommit();
    viewType.value = type;
  }

  ///开关动画
  openOrCloseAni(bool isOpen) {
    if (isOpenTurn) return;
    GameService().isWheelGameAniOpen.value = isOpen;
  }

  ///礼物说明
  openRule() {
    if (isOpenTurn) return;
    Get.dialog(Center(
      child: WheelGameRuleDialog(
        text: viewType.value == GameSubViewType.primary
            ? (GameService().primaryModel?.desc ?? "")
            : (GameService().advancedModel?.desc ?? ""),
      ),
    ));
  }

  ///充值
  gotoRecharge() {
    if (isOpenTurn) return;
    Get.toNamed(AppRouter().walletPages.rechargeRoute.name);
  }

  ///赠送
  onSend(int giftCount) async {
    if (isOpenTurn) return;
    tempList = null;
    int index = Random().nextInt(GameService().primaryPrices.length);
    if (index == 0) index = 1;
    Gift? gift;
    switch (viewType.value) {
      case GameSubViewType.primary:
        gift = GameService().primaryModel?.showList?[index - 1];
        break;
      case GameSubViewType.advanced:
        gift = GameService().advancedModel?.showList?[index - 1];
        break;
    }
    sendModel.gift = gift!;
    if (sendModel.gift.id == null || sendModel.gift.id == 0) {
      sendModel.gift.id = 207;
    }
    sendModel.giftCount = giftCount;
    showCommit();
    sendMsg.sendGift(sendModel, true,
        callBack: (IMCustomMessageModel<IMGiftModel>? model) {
      hiddenCommit();
      if (model != null) {
        tempList = model.data?.gift?.childList;
        isOpenTurn = true;
        turnKey.currentState?.drawClick(index);
      }
    });
  }

  onStop() {
    isOpenTurn = false;
    if (tempList != null) {
      Get.dialog(Center(
        child: WheelGameResultDialog(
          giftList: tempList ?? [],
          onReSend: () {
            Get.back();
            ///重新送
            onSend(sendModel.giftCount);
          },
        ),
      ));
    }
  }
}
