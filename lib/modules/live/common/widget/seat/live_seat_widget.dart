import 'package:youyu/modules/live/common/model/mic_seat_state.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/models/my_getuserinfo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'live_seat_item.dart';

///麦位信息
class LiveSeatWidget extends StatelessWidget {
  const LiveSeatWidget(
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
              ///1个主播席位
              LiveSeatItem(
                isShowSonar: talkingUsers.contains(mics[0].user?.id),
                index: mics[0].position,
                micSeatState: mics[0],
                onMicTap: onMicTap,
                onUserCardTap: () {
                  onUserTap(mics[0].user, 0, mics[0]);
                },
              ),
              SizedBox(
                height: 7.h,
              ),

              ///8个用户席位
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
                        crossAxisCount: 4,
                        //子Widget宽高比例
                        childAspectRatio: 64 / 102,
                      ),
                      itemCount: mics.length - 1,
                      itemBuilder: (BuildContext context, int index) {
                        MicSeatState state = mics[index + 1];
                        return LiveSeatItem(
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
