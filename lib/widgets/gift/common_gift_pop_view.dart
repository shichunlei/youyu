import 'dart:ui';
import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/widgets/gift/sub/common_gift_pop_sub_view.dart';
import 'package:youyu/widgets/gift/widget/common_gift_tab_bar.dart';
import 'package:youyu/widgets/gift/widget/common_gift_user_item.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/models/gift.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/router/router.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_round_container.dart';
import 'package:youyu/widgets/app/icon/app_more_icon.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';
import 'common_gift_pop_logic.dart';
import 'model/common_gift_pop_model.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';

class CommonGiftPopPage extends StatefulWidget {
  const CommonGiftPopPage({
    Key? key,
    this.giftUserList,
    required this.isShowUserList,
    this.roomId,
    this.receiver,
    required this.isSeatUsers,
    required this.onSend,
     this.onGame,
  }) : super(key: key);

  ///直播间使用
  //房间id
  final int? roomId;

  //是否是麦位用户
  final bool isSeatUsers;

  //是否显示用户列表
  final bool isShowUserList;

  //用户列表
  final List<GiftUserPositionInfo>? giftUserList;

  ///会话使用
  final UserInfo? receiver;

  final Function(CommonGiftSendModel? model) onSend;

  final Function(CommonGiftSendModel model)? onGame;

  @override
  State<CommonGiftPopPage> createState() => _CommonGiftPopPageState();
}

class _CommonGiftPopPageState extends State<CommonGiftPopPage>
    with TickerProviderStateMixin {
  final logic = Get.put(CommonGiftPopLogic());

  //用户列表高度
  final double userListHeight = 40.h;

  //礼物列表tabController
  TabController? tabController;

  @override
  void initState() {
    super.initState();

    ///参数赋值
    logic.roomId = widget.roomId;
    logic.receiver = widget.receiver;
    logic.isSeatUsers = widget.isSeatUsers;
    logic.isShowUserList = widget.isShowUserList;
    List<GiftUserPositionInfo> giftUserList = widget.giftUserList ?? [];
    for (GiftUserPositionInfo pInfo in giftUserList) {
      ///过滤掉自己
      if (pInfo.user.id != UserController.to.id) {
        logic.giftUserList.add(pInfo);
      }
    }

    ///获取数据
    logic.fetchGiftList();

    ///tab controller
    tabController = TabController(vsync: this, length: logic.tabs.length);
    tabController?.addListener(() {
      logic.updateGiftType(tabController?.index ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: AppColumn(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            width: double.infinity,
            padding: EdgeInsets.only(top: 10.h),
            color: const Color(0x99181818),
            topRightRadius: 12.w,
            topLeftRadius: 12.w,
            children: [
              Column(
                children: [
                  _widgetUser(),
                  _giftList(),
                ],
              ),
              _bottom()
            ],
          )),
    );
  }

  _widgetUser() {
    if (widget.isSeatUsers) {
      if (widget.isShowUserList) return _userList();
    } else {
      if (widget.isShowUserList) return _singleUser();
    }
    return const SizedBox.shrink();
  }

  ///用户列表
  _userList() {
    return SizedBox(
        width: double.infinity,
        height: 32.h,
        child: ListView.separated(
          padding: EdgeInsets.only(left: 15.w),
          separatorBuilder: (context, index) {
            return VerticalDivider(
              width: 10.w,
              color: Colors.transparent,
            );
          },
          itemCount: logic.giftUserList.length + 1,
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GetBuilder<CommonGiftPopLogic>(
                id: CommonGiftPopLogic.userListId,
                builder: (s) {
                  if (index == 0) {
                    return Center(
                      child: AppRoundContainer(
                          width: 32.h,
                          height: 32.h,
                          padding: EdgeInsets.zero,
                          alignment: Alignment.center,
                          bgColor: logic.isSelectedAllUser
                              ? AppTheme.colorMain
                              : const Color(0xFFD8D8D8),
                          onTap: () {
                            // logic.onSelectedUserAllOrCancel();
                          },
                          child: Text("全麦",
                              style: AppTheme().textStyle(
                                  fontSize: 8.sp,
                                  color: const Color(0xFF000000)))),
                    );
                  }
                  GiftUserPositionInfo model = logic.giftUserList[index - 1];
                  return Center(
                    child: GestureDetector(
                      onTap: () {
                        logic.onSelectedUser(model.user.id ?? 0);
                      },
                      child: CommonGiftUserItem(
                        width: 32.h,
                        height: 32.h,
                        isSelected: logic.selectedUsers.contains(model.user.id),
                        model: model,
                        isSingleUser: false,
                      ),
                    ),
                  );
                });
          },
        ));
  }

  ///单个用户
  _singleUser() {
    return SizedBox(
        width: double.infinity,
        height: 32.h,
        child: ListView.separated(
          padding: EdgeInsets.only(left: 15.w),
          separatorBuilder: (context, index) {
            return VerticalDivider(
              width: 10.w,
              color: Colors.transparent,
            );
          },
          itemCount: logic.giftUserList.length,
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GetBuilder<CommonGiftPopLogic>(
                id: CommonGiftPopLogic.userListId,
                builder: (s) {
                  GiftUserPositionInfo model = logic.giftUserList[index];
                  return Center(
                    child: GestureDetector(
                      onTap: () {
                        logic.onSelectedUser(model.user.id ?? 0);
                      },
                      child: CommonGiftUserItem(
                        width: 32.h,
                        height: 32.h,
                        isSelected: logic.selectedUsers.contains(model.user.id),
                        model: model,
                        isSingleUser: true,
                      ),
                    ),
                  );
                });
          },
        ));
  }

  ///礼物列表
  _giftList() {
    return AppColumn(
        height: 280.h,
        padding: EdgeInsets.only(top: 6.h),
        children: [
          AppRow(
            mainAxisSize: MainAxisSize.max,
            padding: EdgeInsets.only(left: 15.w, right: 15.w),
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CommonGiftTabBar(
                  tabs: logic.tabs,
                  controller: tabController,
                  height: 38.h,
                ),
              ),
              AppMoreIcon(
                onTap: () {
                  Get.toNamed(AppRouter().otherPages.giftDescRoute.name);
                },
                title: "礼物说明",
                height: 20.h,
                imageColor: AppTheme.colorMain,
                textColor: AppTheme.colorMain,
              )
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          Expanded(
              child: Container(
            color: Colors.transparent,
            child: TabBarView(
                controller: tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: logic.tabs.mapIndexed((index, e) {
                  return CommonGiftPopSubPage(
                    key: ValueKey(e.id),
                    tabIndex: index,
                    tab: e,
                    onTap: (Gift gift, int giftTypeId) {
                      CommonGiftSendModel? sendModel = logic.updateGiftInfo(gift, giftTypeId);
                      if (sendModel != null) {
                        //TODO:点击了游戏
                        if (widget.onGame != null) {
                          widget.onGame!(sendModel);
                        }
                      }
                    },
                  );
                }).toList()),
          )),
        ]);
  }

  ///底部
  _bottom() {
    return Container(
      height: 30.h,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      margin:
          EdgeInsets.only(bottom: ScreenUtils.safeBottomHeight + 4.h, top: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_coinRecharge(), _customCountSend()],
      ),
    );
  }

  ///充值
  _coinRecharge() {
    return Obx(() => AppRow(
          onTap: () {
            Get.back();
            Get.toNamed(AppRouter().walletPages.rechargeRoute.name);
          },
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppLocalImage(
              path: AppResource().coin2,
              width: 15.w,
            ),
            SizedBox(
              width: 7.w,
            ),
            Text(
              UserController.to.coins.toString(),
              style: AppTheme()
                  .textStyle(fontSize: 14.sp, color: AppTheme.colorTextWhite),
            ),
            SizedBox(
              width: 15.w,
            ),
            Text(
              "充值",
              style: AppTheme()
                  .textStyle(fontSize: 14.sp, color: AppTheme.colorMain),
            ),
          ],
        ));
  }

  ///自定义数量送礼
  _customCountSend() {
    return AppRoundContainer(
        padding: EdgeInsets.zero,
        bgColor: Colors.transparent,
        width: 122.w,
        height: 30.h,
        border: Border.all(
          width: 1.w,
          color: AppTheme.colorMain,
        ),
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: AppRow(
                  onTap: logic.showCountSheet,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 2.w,
                    ),
                    Expanded(
                      child: Obx(() => Text(
                            "${logic.giftCount.value}",
                            textAlign: TextAlign.center,
                            style: AppTheme().textStyle(
                                fontSize: 14.sp,
                                color: AppTheme.colorTextWhite),
                          )),
                    ),
                    AppLocalImage(
                      path: AppResource().up,
                      width: 11.sp,
                    ),
                    SizedBox(
                      width: 13.w,
                    )
                  ],
                )),
            Expanded(
                flex: 1,
                child: AppRoundContainer(
                  onTap: () async {
                    //发送礼物
                    CommonGiftSendModel? sendModel = await logic.onSendGift();
                    widget.onSend(sendModel);
                    // if (sendModel != null) {
                    //   Get.back(result: sendModel);
                    // }
                  },
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15.h),
                      bottomRight: Radius.circular(15.h)),
                  gradient: AppTheme().btnGradient,
                  child: Center(
                    child: Text(
                      '送礼',
                      style: AppTheme().textStyle(
                          fontSize: 14.sp, color: AppTheme.colorTextWhite),
                    ),
                  ),
                ))
          ],
        ));
  }

  @override
  void dispose() {
    Get.delete<CommonGiftPopLogic>();
    super.dispose();
  }
}
