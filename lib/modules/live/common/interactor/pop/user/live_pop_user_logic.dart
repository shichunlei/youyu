import 'package:youyu/modules/live/common/interactor/pop/user/Relation_Model.dart';
import 'package:youyu/modules/live/index/operation/live_index_operation.dart';
import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/models/localmodel/item_title_model.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LivePopUserLogic extends AppBaseController {
  late int roomId;

  ///目标人信息
  late int targetUserId;
  UserInfo? targetUserInfo;
  late List<RelationList?> relationList = [];
  late bool isManagerByTarget;
  late bool isOwnerByTarget;
  late bool isOnWheatByTarget;
  bool isMine = false;

  ///操作人信息
  late bool isOwnerByOp;
  late bool isManagerByOp;

  //是否禁麦
  late bool isDisableMic;

  ///底部按钮
  double itemW = (ScreenUtils.screenWidth - 26.w - 20.w) / 3;
  late Widget focusBtn;
  late Widget messageBtn;
  late Widget giftBtn;
  final List<Widget> bottomButtons = [];

  ///底部操作
  final List<ItemTitleModel> operations = [];

  double height = 0;

  Function(UserInfo? targetInfo)? updateTargetInfo;

  @override
  void onInit() {
    super.onInit();
    focusBtn = _bottomButton(
        gradientStartColor: const Color(0xFFC6E958),
        gradientEndColor: const Color(0xFf8FCF4F),
        icon: AppResource().liveUserCardAdd,
        title: "加关注",
        onClick: () {
          UserController.to.onFocusUserOrCancel(targetUserInfo, onUpdate: () {
            //通知刷新
            UserController.to.notifyChangeUserFocus(targetUserInfo);
            targetUserInfo?.meIsFocusUser = 1;
            bottomButtons.remove(focusBtn);
            setSuccessType();
          });
        });
    messageBtn = _bottomButton(
        gradientStartColor: const Color(0xFF57F6E6),
        gradientEndColor: const Color(0xFF0392DF),
        icon: AppResource().liveUserCardChat,
        title: "发消息",
        onClick: () {
          onClickEvent(MicOperationType.chat);
        });
    giftBtn = _bottomButton(
        gradientStartColor: const Color(0xFFFF95D3),
        gradientEndColor: const Color(0xFfF85C9F),
        icon: AppResource().liveUserCardGift,
        title: "送礼物",
        onClick: () {
          onClickEvent(MicOperationType.gift);
        });
  }

  loadData(Function(UserInfo? targetInfo)? updateTargetInfo) async {
    this.updateTargetInfo = updateTargetInfo;
    dealWithData(false);
    if (targetUserInfo == null) {
      setNoneType();
      setIsLoading = true;
    }
    UserController.to
        .fetchOtherInfo(targetUserId, roomId: roomId)
        .then((value) {
      targetUserInfo = UserInfo.fromJson(value.data);
      if (updateTargetInfo != null) {
        updateTargetInfo(targetUserInfo);
      }
      paredata(value.data["relation_label"]);

      dealWithData(true);
    }).catchError((e) {
      if (targetUserInfo != null) {
        setErrorType(e);
      }
    });
  }

  paredata(data) {
    // List<dynamic> allList = [];
    for (var temp in data) {
      RelationList userInfo = RelationList.fromJson(temp);
      relationList.add(userInfo);
    }
  }

  dealWithData(bool isRefresh) {
    ///底部按钮
    _dealWithBottomBtn(isRefresh);

    ///底部操作
    _dealWithOperation();

    height = 309.h;
    if (bottomButtons.isEmpty) {
      height = height - 47.h;
    }
    if (operations.isEmpty) {
      height = height - 47.h;
    }

    setSuccessType();
  }

  ///底部按钮
  _dealWithBottomBtn(bool isRefresh) {
    bottomButtons.clear();
    if (!isMine) {
      if (targetUserInfo != null &&
          isRefresh &&
          targetUserInfo?.isFocus == false) {
        bottomButtons.add(focusBtn);
      }
      bottomButtons.add(messageBtn);
      bottomButtons.add(giftBtn);
    }
  }

  ///底部操作按钮
  _dealWithOperation() {
    operations.clear();
    //先判断是否是自己
    if (isMine) {
      if (isOnWheatByTarget) {
        operations
            .add(ItemTitleModel(type: MicOperationType.downWheat, title: "旁听"));
      }
    } else {
      //判断角色
      ///主播
      if (isOwnerByOp) {
        //判断是否上麦
        if (isOnWheatByTarget) {
          operations.add(
              ItemTitleModel(type: MicOperationType.downWheat, title: "旁听"));
          operations.add(ItemTitleModel(
              type: isDisableMic
                  ? MicOperationType.cancelDisableMic
                  : MicOperationType.disableMic,
              title: isDisableMic ? "解除禁麦" : "禁麦"));
          operations
              .add(ItemTitleModel(type: MicOperationType.lockMic, title: "封麦"));
          operations
              .add(ItemTitleModel(type: MicOperationType.kickOut, title: "踢出"));
          operations.add(ItemTitleModel(
              type: targetUserInfo?.isMuted == 1
                  ? MicOperationType.cancelForbidden
                  : MicOperationType.forbidden,
              title: targetUserInfo?.isMuted == 1 ? "解除禁言" : "禁言"));
        } else {
          operations
              .add(ItemTitleModel(type: MicOperationType.kickOut, title: "踢出"));
          operations.add(ItemTitleModel(
              type: targetUserInfo?.isMuted == 1
                  ? MicOperationType.cancelForbidden
                  : MicOperationType.forbidden,
              title: targetUserInfo?.isMuted == 1 ? "解除禁言" : "禁言"));
        }
      }

      ///管理员
      else if (isManagerByOp) {
        //判断是否上麦
        if (isOnWheatByTarget) {
          if (!isOwnerByTarget) {
            operations.add(
                ItemTitleModel(type: MicOperationType.downWheat, title: "旁听"));
            operations.add(ItemTitleModel(
                type: isDisableMic
                    ? MicOperationType.cancelDisableMic
                    : MicOperationType.disableMic,
                title: isDisableMic ? "解除禁麦" : "禁麦"));
            operations.add(
                ItemTitleModel(type: MicOperationType.lockMic, title: "封麦"));
            operations.add(
                ItemTitleModel(type: MicOperationType.kickOut, title: "踢出"));
            operations.add(ItemTitleModel(
                type: targetUserInfo?.isMuted == 1
                    ? MicOperationType.cancelForbidden
                    : MicOperationType.forbidden,
                title: targetUserInfo?.isMuted == 1 ? "解除禁言" : "禁言"));
          }
        } else {
          if (!isOwnerByTarget) {
            operations.add(
                ItemTitleModel(type: MicOperationType.kickOut, title: "踢出"));
            operations.add(ItemTitleModel(
                type: targetUserInfo?.isMuted == 1
                    ? MicOperationType.cancelForbidden
                    : MicOperationType.forbidden,
                title: targetUserInfo?.isMuted == 1 ? "解除禁言" : "禁言"));
          }
        }
      }

      ///普通用户
      else {
        //...
      }
    }
  }

  Widget _bottomButton(
      {required Color gradientStartColor,
      required Color gradientEndColor,
      required String icon,
      required String title,
      required Function onClick}) {
    return AppRow(
      onTap: () {
        onClick();
      },
      radius: 99.w,
      mainAxisAlignment: MainAxisAlignment.center,
      gradientBegin: Alignment.centerLeft,
      gradientEnd: Alignment.centerRight,
      gradientStartColor: gradientStartColor,
      gradientEndColor: gradientEndColor,
      width: itemW,
      height: 47.h,
      children: [
        AppLocalImage(
          path: icon,
          width: 24.w,
        ),
        SizedBox(
          width: 10.w,
        ),
        Text(
          title,
          style: AppTheme()
              .textStyle(fontSize: 14.sp, color: AppTheme.colorTextWhite),
        )
      ],
    );
  }

  onClickEvent(MicOperationType eventType) {
    Get.back(result: eventType);
  }

  @override
  void reLoadData() {
    super.reLoadData();
    loadData(updateTargetInfo);
  }
}
