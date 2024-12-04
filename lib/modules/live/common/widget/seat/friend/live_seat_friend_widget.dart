import 'package:youyu/config/resource.dart';
import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/modules/live/common/model/firend_state.dart';
import 'package:youyu/modules/live/common/model/mic_seat_state.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youyu/utils/time_utils.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';

import 'live_seat_friend_item.dart';

///麦位信息
class LiveSeatFriendWidget extends StatelessWidget {
  const LiveSeatFriendWidget({
    super.key,
    this.margin,
    required this.height,
    required this.talkingUsers,
    required this.friendState,
    required this.mics,
    required this.onMicTap,
    required this.onUserTap,
    required this.onOpenTap,
    required this.onEndTap,
    required this.onAddTap,
    required this.onSupportTap,
  });

  final EdgeInsets? margin;
  final double height;
  final RxList<int> talkingUsers;
  final RxList<MicSeatState> mics;
  final Rx<FriendState?> friendState;

  final Future<void> Function(MicSeatState) onMicTap;
  final Function(UserInfo? userInfo, int position, MicSeatState micSeatState)
      onUserTap;
  final Function() onOpenTap;
  final Function() onEndTap;
  final Function() onAddTap;
  final Function(UserInfo userInfo) onSupportTap;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          margin: margin,
          color: Colors.transparent,
          width: double.infinity,
          height: height,
          child: AppStack(
            children: [
              ///心形背景
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.w, right: 10.w),
                  child: AppLocalImage(
                    path: AppResource().liveMarkingRelation,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              ///顶部配对状态
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 35.h, left: 10.w, right: 10.w),
                  child: AppLocalImage(
                    path: friendState.value?.status == 0 ||
                            (friendState.value?.endTime ?? 0) <=
                                DateTime.now().millisecondsSinceEpoch ~/ 1000
                        ? AppResource().liveMarkingState1
                        : (friendState.value?.status == 1
                            ? AppResource().liveMarkingState2
                            : AppResource().liveMarkingState3),
                    height: 20.h,
                  ),
                ),
              ),
              if (mics[0].user?.id == UserController.to.id)
                Padding(
                  padding: EdgeInsets.only(top: 124.h, left: 20.w, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () {
                          final bool isLiveMarkingStart =
                              (friendState.value?.status == 0) ||
                                  ((friendState.value?.endTime ?? 0) <=
                                      DateTime.now().millisecondsSinceEpoch ~/
                                          1000);
                          return AppLocalImage(
                            path: isLiveMarkingStart
                                ? AppResource().liveMarkingStart
                                : AppResource().liveMarkingEnd,
                            width: 40.w,
                            onTap: () {
                              if (isLiveMarkingStart) {
                                onOpenTap();
                              } else {
                                onEndTap();
                              }
                            },
                          );
                        },
                      ),
                      AppLocalImage(
                        path: AppResource().liveMarkingTime,
                        width: 59.w,
                        onTap: () {
                          onAddTap();
                        },
                      ),
                    ],
                  ),
                ),

              // ///开始和增加时间按钮

              ///倒计时
              Padding(
                padding: EdgeInsets.only(top: 5.h, left: 20.w, right: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Spacer(),
                    // Text(
                    //   '倒计时:${logic.friendStateObs.value?.endTime.toString()}秒',
                    //   style:
                    //       const TextStyle(color: Colors.white, fontSize: 10),
                    // )
                    Obx(() => Text(
                              '倒计时: ${TimeUtils.countDownTimeBySeconds((friendState.value?.endTime ?? 0) - DateTime.now().millisecondsSinceEpoch ~/ 1000) ?? 0}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10),
                            )
                        // CountdownTimer(
                        //   endTime: logic.friendStateObs.value!.endTime! -
                        //       DateTime.now().millisecondsSinceEpoch ~/ 1000,
                        // ),
                        )
                  ],
                ),
              ),

              //主持麦和嘉宾麦
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LiveSeatFriendItem(
                        isShowSonar: talkingUsers.contains(mics[0].user?.id),
                        index: mics[0].position,
                        micSeatState: mics[0],
                        onMicTap: onMicTap,
                        onUserCardTap: () {
                          onUserTap(mics[0].user, 0, mics[0]);
                        },
                        onSupportTap: onSupportTap,
                      ),
                      LiveSeatFriendItem(
                        isShowSonar: talkingUsers.contains(mics[1].user?.id),
                        index: mics[1].position,
                        micSeatState: mics[1],
                        onMicTap: onMicTap,
                        onUserCardTap: () {
                          onUserTap(mics[1].user, 1, mics[1]);
                        },
                        onSupportTap: onSupportTap,
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 80.h,
                  ),

                  ///1,2号麦位
                  Stack(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LiveSeatFriendItem(
                            isShowSonar:
                                talkingUsers.contains(mics[2].user?.id),
                            index: mics[2].position,
                            micSeatState: mics[2],
                            onMicTap: onMicTap,
                            onUserCardTap: () {
                              onUserTap(mics[2].user, 2, mics[2]);
                            },
                            onSupportTap: () {
                              onSupportTap(mics[2].user!);
                            }),
                        SizedBox(
                          width: 50.w,
                        ),
                        LiveSeatFriendItem(
                            isShowSonar:
                                talkingUsers.contains(mics[3].user?.id),
                            index: mics[3].position,
                            micSeatState: mics[3],
                            onMicTap: onMicTap,
                            onUserCardTap: () {
                              onUserTap(mics[3].user, 3, mics[3]);
                            },
                            onSupportTap: () {
                              onSupportTap(mics[3].user!);
                            }),
                      ],
                    ),

                    //两人都在麦上开启连线
                    if ((mics[2].state == 1 || mics[2].state == 3) && (mics[3].state == 1 || mics[3].state == 3))
                      HeartLinkWidget(
                        charmSum: mics[2].heart + mics[3].heart,
                        imageWidth: 100.w,
                        imageTop: 20.h,
                        charmTop: 35.h,
                        fontSize: 11.sp,
                      )
                  ]),

                  ///3,4号麦位
                  Stack(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          LiveSeatFriendItem(
                              isShowSonar:
                                  talkingUsers.contains(mics[4].user?.id),
                              index: mics[4].position,
                              micSeatState: mics[4],
                              onMicTap: onMicTap,
                              onUserCardTap: () {
                                onUserTap(mics[4].user, 4, mics[4]);
                              },
                              onSupportTap: () {
                                onSupportTap(mics[4].user!);
                              }),
                          LiveSeatFriendItem(
                              isShowSonar:
                                  talkingUsers.contains(mics[5].user?.id),
                              index: mics[5].position,
                              micSeatState: mics[5],
                              onMicTap: onMicTap,
                              onUserCardTap: () {
                                onUserTap(mics[5].user, 5, mics[5]);
                              },
                              onSupportTap: () {
                                onSupportTap(mics[5].user!);
                              }),
                        ],
                      ),
                    ),
                    if ((mics[4].state == 1 || mics[4].state == 3) && (mics[5].state == 1 || mics[5].state == 3))
                      HeartLinkWidget(
                        charmSum: mics[4].heart + mics[5].heart,
                        imageWidth: 225.w,
                        imageTop: 0,
                        charmTop: 38.h,
                        fontSize: 18.sp,
                      )
                  ]),

                  ///5,6号麦位
                  Stack(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LiveSeatFriendItem(
                            isShowSonar:
                                talkingUsers.contains(mics[6].user?.id),
                            index: mics[6].position,
                            micSeatState: mics[6],
                            onMicTap: onMicTap,
                            onUserCardTap: () {
                              onUserTap(mics[6].user, 6, mics[6]);
                            },
                            onSupportTap: () {
                              onSupportTap(mics[6].user!);
                            }),
                        SizedBox(
                          width: 50.w,
                        ),
                        LiveSeatFriendItem(
                            isShowSonar:
                                talkingUsers.contains(mics[7].user?.id),
                            index: mics[7].position,
                            micSeatState: mics[7],
                            onMicTap: onMicTap,
                            onUserCardTap: () {
                              onUserTap(mics[7].user, 7, mics[7]);
                            },
                            onSupportTap: () {
                              onSupportTap(mics[7].user!);
                            }),
                      ],
                    ),
                    if ((mics[6].state == 1 || mics[6].state == 3) && (mics[7].state == 1 || mics[7].state == 3))
                      HeartLinkWidget(
                          charmSum: mics[6].heart + mics[7].heart,
                          imageWidth: 100.w,
                          imageTop: 15.h,
                          charmTop: 30.h,
                          fontSize: 11.sp)
                  ]),
                ],
              ),
            ],
          ),
        ));
  }
}

class HeartLinkWidget extends StatelessWidget {
  const HeartLinkWidget({
    super.key,
    required this.charmSum,
    required this.imageWidth,
    required this.imageTop,
    required this.charmTop,
    required this.fontSize,
  });

  final int charmSum;
  final double imageWidth;
  final double imageTop;
  final double charmTop;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    String imagePath;

    if (charmSum == 0) {
      return Container(); // 如果 charmSum 为 0，则不显示任何内容
    } else if (charmSum < 500) {
      imagePath = AppResource().liveHeart1;
    } else if (charmSum < 1000) {
      imagePath = AppResource().liveHeart2;
    } else if (charmSum < 10000) {
      imagePath = AppResource().liveHeart3;
    } else {
      imagePath = AppResource().liveHeart4;
    }

    return SizedBox(
      width: double.infinity, // 确保父部件有明确的大小
      height: 100.h, // 确保父部件有明确的大小

      child: Stack(
        children: [
          Positioned(
            top: imageTop, // 将图片定位到 Row 的上方
            left: 0,
            right: 0,
            child: Center(
              child: AppLocalImage(
                path: imagePath,
                width: imageWidth,
              ),
            ),
          ),
          Positioned(
            top: charmTop, // 将图片定位到 Row 的上方
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '$charmSum',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
