import 'package:youyu/modules/live/common/model/mic_seat_state.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'live_seat_bar_item.dart';

///麦位信息
class LiveSeatBarWidget extends StatelessWidget {
  const LiveSeatBarWidget(
      {super.key,
      this.margin,
      required this.height,
      required this.talkingUsers,
      required this.mics,
      required this.onMicTap,
      required this.onUserTap});

  final EdgeInsets? margin;
  final double height;
  final RxList<int> talkingUsers;
  final RxList<MicSeatState> mics;

  final Future<void> Function(MicSeatState) onMicTap;
  final Function(UserInfo? userInfo, int position, MicSeatState micSeatState)
      onUserTap;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          margin: margin,
          color: Colors.transparent,
          width: double.infinity,
          height: height,
          child: Column(
            children: [
              ///主播席位和嘉宾席位
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LiveSeatBarItem(
                        isShowSonar: talkingUsers.contains(mics[0].user?.id),
                        index: mics[0].position,
                        micSeatState: mics[0],
                        onMicTap: onMicTap,
                        onUserCardTap: () {
                          onUserTap(mics[0].user, 0, mics[0]);
                        },
                      ),
                      LiveSeatBarItem(
                        isShowSonar: talkingUsers.contains(mics[1].user?.id),
                        index: mics[1].position,
                        micSeatState: mics[1],
                        onMicTap: onMicTap,
                        onUserCardTap: () {
                          onUserTap(mics[1].user, 1, mics[1]);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 7.h,
              ),

              ///6个用户席位
              Expanded(
                  child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.only(left: 17.w, right: 17.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //水平子Widget之间间距
                        crossAxisSpacing: 25.w,
                        //垂直子Widget之间间距
                        mainAxisSpacing: 7.h,
                        //一行的Widget数量
                        crossAxisCount: 3,
                        //子Widget宽高比例
                        childAspectRatio: 64 / 80,
                      ),
                      itemCount: mics.length - 3,
                      itemBuilder: (BuildContext context, int index) {
                        MicSeatState state = mics[index + 2];
                        return LiveSeatBarItem(
                          isShowSonar: talkingUsers.contains(state.user?.id),
                          index: state.position,
                          micSeatState: state,
                          onMicTap: onMicTap,
                          onUserCardTap: () {
                            onUserTap(state.user, state.position, state);
                          },
                        );
                      }))
            ],
          ),
        ));
  }
}
