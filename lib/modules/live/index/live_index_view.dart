import 'dart:async';
import 'package:youyu/modules/live/common/widget/bg/live_bg_widget.dart';
import 'package:youyu/modules/live/common/widget/input/live_input_widget.dart';
import 'package:youyu/modules/live/common/widget/nav/live_nav_bar.dart';
import 'package:youyu/modules/live/common/widget/notice/live_notice_widget.dart';
import 'package:youyu/modules/live/common/widget/screen/live_screen_widget.dart';
import 'package:youyu/modules/live/common/widget/seat/bar/live_seat_bar_widget.dart';
import 'package:youyu/modules/live/common/widget/seat/friend/live_seat_friend_widget.dart';
import 'package:youyu/modules/live/common/widget/seat/live_seat_widget.dart';
import 'package:youyu/modules/live/common/widget/worldmsg/live_word_msg_view.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/tag_utils.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:youyu/widgets/app/app_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/widgets/gift/model/common_gift_pop_model.dart';
import 'live_index_logic.dart';

class LiveIndexPage extends StatelessWidget {
  LiveIndexPage({Key? key}) : super(key: key);

  final logic = Get.find<LiveIndexLogic>(tag: AppTapUtils.tag);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => exitVerify(),
        child: SizedBox(
          width: ScreenUtils.screenWidth,
          height: ScreenUtils.screenHeight,
          child: Listener(
            child: Stack(
              children: [
                ///背景
                LiveBgWidget(
                  key: logic.onBackGroundKey(),
                ),

                ///主体
                AppPage<LiveIndexLogic>(
                  tag: AppTapUtils.tag,
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Colors.transparent,
                  appBar: LiveNavBar(
                    roomName: logic.viewObs.name,
                    roomType: logic.viewObs.roomType,
                    liveFancyNumber: logic.liveFancyNumber,
                    liveHot: logic.viewObs.liveHot,
                    top3UserList: logic.viewObs.top3UserList,
                    onlineUserList: logic.viewObs.onlineUserList,
                    onClickUserList: logic.operation.onOperateUserList,
                    onClickTopMore: logic.operation.onOperateTopMore,
                    isFocus: logic.viewObs.isFocusLive,
                    onClickLiveFocus: logic.operation.onOperateFocusLive,
                    isLock: logic.viewObs.lock,
                  ),
                  childBuilder: (s) {
                    return Column(
                      children: [
                        // 如果type是交友, 就显示麦位jy 不是就显示麦位置
                        switch (logic.viewObs.roomType.value) {
                          '交友' => LiveSeatFriendWidget(
                              friendState: logic.friendStateObs,
                              margin: EdgeInsets.only(
                                  top: logic.viewObs.seatMarginTop),
                              height: 374.h,
                              // height: 394.h,
                              talkingUsers: logic.onSeatTalkingUsers(),
                              mics: logic.onSeatMics(),
                              onMicTap: (micSeatState) async {
                                logic.operation.onOperateOnMic(micSeatState);
                              },
                              onUserTap: (userInfo, position, mic) {
                                if (userInfo != null) {
                                  logic.operation.onOperateShowUserCard(
                                      userInfo,
                                      position: position);
                                }
                              },
                              onOpenTap: () {
                                logic.friendopen();
                              },
                              onEndTap: () {
                                logic
                                    .friendend(logic.friendStateObs.value?.id!);
                              },
                              onAddTap: () {
                                logic.friendaddtime(
                                    logic.friendStateObs.value?.id!);
                              },
                              onSupportTap: (userinfo) {
                                logic.operation.onOperateGift([
                                  GiftUserPositionInfo(
                                      position: 0, user: userinfo)
                                ], isSeatUsers: false, isSupportGift: true);
                              }),
                          '酒吧' => LiveSeatBarWidget(
                              margin: EdgeInsets.only(
                                  top: logic.viewObs.seatMarginTop),
                              height: 360.h,
                              talkingUsers: logic.onSeatTalkingUsers(),
                              mics: logic.onSeatMics(),
                              onMicTap: (micSeatState) async {
                                logic.operation.onOperateOnMic(micSeatState);
                              },
                              onUserTap: (userInfo, position, mic) {
                                if (userInfo != null) {
                                  logic.operation.onOperateShowUserCard(
                                      userInfo,
                                      position: position);
                                }
                              },
                            ),
                          _ => LiveSeatWidget(
                              margin: EdgeInsets.only(
                                  top: logic.viewObs.seatMarginTop),
                              height: logic.viewObs.seatAllHeight,
                              talkingUsers: logic.onSeatTalkingUsers(),
                              mics: logic.onSeatMics(),
                              onMicTap: (micSeatState) async {
                                logic.operation.onOperateOnMic(micSeatState);
                              },
                              onUserTap: (userInfo, position, mic) {
                                if (userInfo != null) {
                                  logic.operation.onOperateShowUserCard(
                                      userInfo,
                                      position: position);
                                }
                              },
                            ),
                        },
                        // if (LiveIndexLogic.to.liveWorldMsgObs != Rx(null))
                        const LiveWorldMsgView(),
                        // ///麦位和公屏之间增加23，留出总共37的高度给礼物公告占用
                        // SizedBox(
                        //   height: 23.h,
                        // ),

                        ///公屏 (内部有14的上边距，用来占位)
                        Expanded(
                            child: LiveScreenWidget(
                          key: logic.notification?.screenNotify.screenKey,
                          pageTag: logic.pageTag,
                          onClickItem: logic.operation.onOperateScreenItem,
                          onClickUser: (UserInfo userInfo) {
                            logic.operation.onOperateShowUserCard(userInfo);
                          },
                          onClickLink: logic.operation.onOperateLink,
                        )),
                      ],
                    );
                  },

                  ///底部input
                  bottomBar: LiveInputWidget(
                    onClickInput: () {
                      logic.operation.onOperateInput();
                    },
                    onClickVolume: () {
                      logic.operation.onOperateVolume();
                    },
                    onClickCloseMic: logic.operation.onOperateCloseMic,
                    onClickOpenMic: logic.operation.onOperateOpenMic,
                    onClickUpMicTap: () {
                      logic.operation.onOperateUpMicTap();
                    },
                    onClickDownMicTap: () {
                      logic.operation.onOperateDownMicTap();
                    },
                    onClickBottomMore: logic.operation.onOperateBottomMore,
                    onClickMsg: logic.operation.onOperateConversation,
                    onClickGift: () {
                      logic.operation.onOperateGift(logic.onSeatMicUsers());
                    },
                    onClickEmoji: () {
                      logic.operation.onOperateEmoji();
                    },
                  ),
                ),

                // ///开始和增加时间按钮
                // Padding(
                //   padding: EdgeInsets.only(top: 248.h, left: 20.w, right: 20),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Obx(
                //         () {
                //           final bool isLiveMarkingStart =
                //               logic.friendStateObs.value?.status == 0 ||
                //                   logic.friendStateObs.value!.endTime! <=
                //                       DateTime.now().millisecondsSinceEpoch ~/
                //                           1000;
                //           return AppLocalImage(
                //             path: isLiveMarkingStart
                //                 ? AppResource().liveMarkingStart
                //                 : AppResource().liveMarkingEnd,
                //             width: 40.w,
                //             onTap: () {
                //               if (isLiveMarkingStart) {
                //                 logic.friendopen();
                //               } else {
                //                 logic.friendend(logic.friendStateObs.value?.id);
                //               }
                //             },
                //           );
                //         },
                //       ),
                //       AppLocalImage(
                //         path: AppResource().liveMarkingTime,
                //         width: 59.w,
                //         onTap: () {
                //           logic.friendaddtime(logic.friendStateObs.value?.id);
                //         },
                //       ),
                //     ],
                //   ),
                // ),

                ///倒计时
                // Padding(
                //   padding: EdgeInsets.only(top: 100.h, left: 20.w, right: 20.w),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       const Spacer(),
                //       // Text(
                //       //   '倒计时:${logic.friendStateObs.value?.endTime.toString()}秒',
                //       //   style:
                //       //       const TextStyle(color: Colors.white, fontSize: 10),
                //       // )
                //       Obx(() => Text(
                //                 '倒计时: ${TimeUtils.countDownTimeBySeconds((logic.friendStateObs.value?.endTime ?? 0) - DateTime.now().millisecondsSinceEpoch ~/ 1000) ?? 0}',
                //                 style: const TextStyle(
                //                     color: Colors.white, fontSize: 10),
                //               )
                //           // CountdownTimer(
                //           //   endTime: logic.friendStateObs.value!.endTime! -
                //           //       DateTime.now().millisecondsSinceEpoch ~/ 1000,
                //           // ),
                //           )
                //     ],
                //   ),
                // ),

                ///礼物上下公告(作为widget,在麦位和公屏中间)
                // Positioned(
                //     left: 0,
                //     right: 0,
                //     top: ScreenUtils.statusBarHeight +
                //         ScreenUtils.navbarHeight +
                //         logic.viewObs.seatMarginTop +
                //         logic.viewObs.seatAllHeight,
                //     child: SizedBox(
                //       height: 37.h,
                //       child:
                //           logic.notification?.giftSlideNotify.giftNoticeWidget,
                //     )),

                ///公告
                Positioned(
                    left: 20.h,
                    top: ScreenUtils.navbarHeight +
                        ScreenUtils.statusBarHeight +
                        18.h,
                    child:
                        Obx(() => logic.viewObs.notice.value.isNotEmpty == true
                            ? LiveNoticeWidget(
                                onTap: (nContext) {
                                  logic.operation.onOperateNotice(nContext);
                                },
                              )
                            : const SizedBox.shrink())),

                ///顶部风格飘屏
                Positioned(
                    top: ScreenUtils.statusBarHeight + 20.h,
                    child: IgnorePointer(
                      child: Column(
                        children: logic
                                .notification?.topSlideNotify.screenSlideList ??
                            [],
                      ),
                    )),

                ///vip风格漂屏
                Positioned(
                    left: 0,
                    right: 0,
                    top: ScreenUtils.statusBarHeight +
                        ScreenUtils.navbarHeight +
                        (logic.viewObs.seatMarginTop) +
                        (logic.viewObs.seatAllHeight) -
                        5.h,
                    child: SizedBox(
                      height: 37.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            logic.notification?.vipSlideNotify.vipSlideList ??
                                [],
                      ),
                    )),

                ///tip风格飘屏
                Positioned(
                    top: ScreenUtils.statusBarHeight +
                        ScreenUtils.navbarHeight +
                        100.h,
                    child: IgnorePointer(
                      child: Column(
                        children: logic
                                .notification?.tipSlideNotify.screenSlideList ??
                            [],
                      ),
                    )),

                ///进入风格飘屏
                Positioned(
                    top: logic.viewObs.joinSlideTop,
                    child: IgnorePointer(
                      child: Column(
                        children: logic.notification?.joinSlideNotify
                                .screenSlideList ??
                            [],
                      ),
                    )),

                ///中间礼物风格飘屏
                Obx(
                  () => Positioned(
                      top: logic.viewObs.giftSlideTop.value,
                      child: IgnorePointer(
                        child: Column(
                          children: logic.notification?.giftSlideNotify
                                  .screenSlideList ??
                              [],
                        ),
                      )),
                ),

                ///礼物特效
                Obx(() => logic.isCloseAni.value
                    ? const SizedBox.shrink()
                    : Positioned(
                        top: 0,
                        right: 0,
                        bottom: 0,
                        left: 0,
                        child: IgnorePointer(
                          child: SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: logic
                                .notification?.giftSlideNotify.bigAniWidget,
                          ),
                        ))),
              ],
            ),
          ),
        ));
  }

  Future<bool> exitVerify() async {
    return Future.value(false);
  }
}
