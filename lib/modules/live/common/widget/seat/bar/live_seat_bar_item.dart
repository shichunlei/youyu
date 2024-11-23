import 'dart:io';

import 'package:youyu/controllers/user/user_controller.dart';
import 'package:youyu/modules/live/common/model/mic_seat_state.dart';
import 'package:youyu/modules/live/index/live_index_logic.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:youyu/utils/toast_utils.dart';
import 'package:youyu/widgets/app/button/app_color_button.dart';

import 'package:youyu/widgets/svga/simple_player_ext.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/services/async_down_service.dart';
import 'package:youyu/config/resource.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/image/app_net_image.dart';
import 'package:flutter/material.dart';

class LiveSeatBarItem extends StatefulWidget {
  const LiveSeatBarItem(
      {super.key,
      required this.index,
      required this.micSeatState,
      required this.isShowSonar,
      required this.onMicTap,
      required this.onUserCardTap});

  //索引
  final int index;

  //麦位信息
  final MicSeatState micSeatState;

  //是否显示声音动画
  final bool isShowSonar;

  //上麦操作
  final Future<void> Function(MicSeatState micSeatState) onMicTap;

  //用户资料卡
  final Function onUserCardTap;

  @override
  State<LiveSeatBarItem> createState() => _LiveSeatBarItemState();
}

class _LiveSeatBarItemState extends State<LiveSeatBarItem> {
  //头像框
  File? headFile;

  //音麦
  File? audioFile;

  int? userId;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppStack(
          clipBehavior: Clip.none,
          width: 81.w,
          height: 81.w,
          children: [
            ///顶部背景
            Container(
                alignment: Alignment.topCenter,
                child: AppStack(
                  width: 67.w,
                  height: 67.w,
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [_micSeatStatesBg(), _micMute()],
                )),

            ///号码或昵称
            Positioned(
                right: 0, left: 0, bottom: 0, child: _micSeatNameOrNum()),

            ///光圈
            Transform(
              transform: Matrix4.translationValues(0.0, -5.w, 0),
              child: Container(
                alignment: Alignment.topCenter,
                child: _audioWheat(),
              ),
            )
          ],
        ),
        if (widget.index >= 2)
          AppContainer(
            margin: EdgeInsets.only(top: 4.h),
            child: Text(
              widget.micSeatState.wishGiftId == 0
                  ? '设置才艺礼物'
                  : "心愿: ${LiveIndexLogic.to.barGiftList.firstWhere((element) => element!.id == widget.micSeatState.wishGiftId)!.name}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTheme()
                  .textStyle(fontSize: 8.sp, color: AppTheme.colorTextWhite),
            ),
            onTap: () {
              if (userId == UserController.to.id) {
                LiveIndexLogic.to.operation.onOperateBarGift();
              }
            },
          ),
        if (widget.index >= 2)
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppColorButton(
                  title: '才艺',
                  height: 17.5.h,
                  width: 41.w,
                  bgGradient: AppTheme().btnGradient,
                  titleColor: AppTheme.colorTextWhite,
                  fontSize: 10.sp,
                  padding: EdgeInsets.zero,
                  onClick: () {
                    if (widget.micSeatState.wishGiftId == 0) {
                      ToastUtils.show('用户暂未设置心愿礼物');
                      return;
                    }

                    if (widget.micSeatState.state == 1 &&
                        widget.micSeatState.wishGiftId != 0 &&
                        userId != UserController.to.id) {
                      LiveIndexLogic.to.operation.onOperateBarGiveGift(
                          userlist: [widget.micSeatState.user],
                          gift: LiveIndexLogic.to.barGiftList.firstWhere(
                              (element) =>
                                  element!.id ==
                                  widget.micSeatState.wishGiftId));
                    }
                  },
                ),
                SizedBox(
                  width: 5.w,
                ),
                AppContainer(
                  radius: 20.w,
                  height: 17.5.h,
                  width: 41.w,
                  gradientStartColor: const Color(0xFFFF95D3),
                  gradientEndColor: const Color(0xFfF85C9F),
                  child: Text(
                    '撩TA',
                    textAlign: TextAlign.center,
                    style: AppTheme()
                        .textStyle(fontSize: 10.sp, color: Colors.white),
                  ),
                  onTap: () => {
                    if (widget.micSeatState.state == 1 &&
                        userId != UserController.to.id)
                      LiveIndexLogic.to.operation.onOperateBarGiveGift(
                          userlist: [widget.micSeatState.user],
                          gift: LiveIndexLogic.to.flirtGift)
                  },
                )
              ],
            ),
          ),
      ],
    );
  }

  ///麦位背景
  /// 0：空位
  /// 1：上麦
  /// 2：锁麦
  _micSeatStatesBg() {
    switch (widget.micSeatState.state) {
      case 0:
        return AppStack(
          onTap: () {
            widget.onMicTap(widget.micSeatState);
          },
          alignment: Alignment.center,
          width: 48.w,
          height: 48.w,
          children: [
            AppLocalImage(
              path: widget.index == 1
                  ? AppResource().liveMarkingAmd
                  : AppResource().liveSeatBg,
              width: 48.w,
              height: 48.w,
              fit: BoxFit.fill,
            ),
            AppLocalImage(
              path: (widget.index == 1)
                  ? AppResource().liveSeatSofa
                  : AppResource().liveSeatNormalSofa,
              width: 15.w,
              height: 15.w,
              fit: BoxFit.fill,
            )
          ],
        );
      case 2:
        return GestureDetector(
          onTap: () {
            widget.onMicTap(widget.micSeatState);
          },
          child: SizedBox(
            width: 48.w,
            height: 48.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AppLocalImage(
                  path: AppResource().liveSeatBg,
                  width: 48.w,
                  height: 48.w,
                  fit: BoxFit.fill,
                ),
                Positioned(
                    top: 15.h,
                    child: AppLocalImage(
                      path: AppResource().liveSeatLock,
                      width: 15.w,
                    ))
              ],
            ),
          ),
        );
      default:
        if (widget.micSeatState.user?.id != null &&
            userId == widget.micSeatState.user?.id) {
          if (headFile == null) {
            _loadHeadFile();
          }
          if (audioFile == null) {
            _loadAudioFile();
          }
        } else {
          headFile = null;
          audioFile = null;
          _loadHeadFile();
          _loadAudioFile();
        }
        userId = widget.micSeatState.user?.id;
        return AppStack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            AppContainer(
              onTap: () {
                widget.onUserCardTap();
              },
              child: Align(
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  child: AppNetImage(
                    imageUrl: widget.micSeatState.user?.avatar,
                    width: 48.w,
                    height: 48.w,
                    fit: BoxFit.cover,
                    defaultWidget: const SizedBox.shrink(),
                  ),
                ),
              ),
            ),

            ///底部数值
            Align(
              alignment: Alignment.bottomCenter,
              child: UnconstrainedBox(
                child: AppContainer(
                  radius: 100,
                  color: Colors.black.withOpacity(0.6),
                  margin: EdgeInsets.only(bottom: 9.h),
                  constraints: BoxConstraints(
                    minWidth: 31.w,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(1.5.w),
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppLocalImage(
                            path: AppResource().coin1,
                            height: 8.h,
                          ),
                          SizedBox(
                            width: 2.w,
                          ),
                          Text(
                            widget.micSeatState.charm.toString(),
                            style: AppTheme().textStyle(
                                fontSize: 8.sp, color: AppTheme.colorTextWhite),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            _headBorder()
          ],
        );
    }
  }

  _loadHeadFile() async {
    if (widget.micSeatState.user?.dressHead()?.res?.isNotEmpty == true) {
      headFile = await AsyncDownService().addTask(DownType.header,
          DownModel(url: widget.micSeatState.user?.dressHead()?.res ?? ""));
      setState(() {});
    }
  }

  ///头像框
  _headBorder() {
    if (headFile != null) {
      return SizedBox(
          width: 55.w,
          height: 55.w,
          // child: SVGAImage(controller),
          child: SVGASimpleImageExt(
            key: ValueKey(widget.micSeatState.user?.id),
            file: headFile,
            fit: BoxFit.cover,
          ));
    }
    return const SizedBox.shrink();
  }

  ///音麦
  _audioWheat() {
    if (widget.isShowSonar) {
      if (audioFile != null) {
        return SizedBox(
            width: 77.w,
            height: 77.w,
            child: SVGASimpleImageExt(
              key: ValueKey((widget.micSeatState.user?.id ?? 0) + 1),
              file: audioFile,
              fit: BoxFit.cover,
            ));
      } else {
        return SizedBox(
            width: 77.w,
            height: 77.w,
            child: SVGASimpleImageExt(
              key: ValueKey((widget.micSeatState.user?.id ?? 0) + 2),
              assetsName: AppResource.getSvga('aperture_default'),
              fit: BoxFit.cover,
            ));
      }
    } else {
      return const SizedBox();
    }
  }

  _loadAudioFile() async {
    if (widget.micSeatState.user?.dressWheat()?.res?.isNotEmpty == true) {
      audioFile = await AsyncDownService().addTask(DownType.audioWheat,
          DownModel(url: widget.micSeatState.user?.dressWheat()?.res ?? ""));
      setState(() {});
    }
  }

  ///是否闭麦
  _micMute() {
    return widget.micSeatState.mute == 1
        ? Positioned(
            bottom: 6.w,
            right: 6.w,
            child: Container(
              width: 19.w,
              height: 19.w,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: Color(0xFF464646)),
              child: Center(
                child: AppLocalImage(
                  width: 14.w,
                  path: AppResource().liveMute,
                ),
              ),
            ),
          )
        : const SizedBox();
  }

  ///麦位号码或昵称
  _micSeatNameOrNum() {
    return AppRow(
      alignment: Alignment.center,
      width: double.infinity,
      // color: Colors.amber,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.index > 1)
          AppLocalImage(
            path: AppResource().liveSeat(widget.index - 1),
            width: 10.w,
            height: 10.w,
          ),
        if (widget.index > 0)
          SizedBox(
            width: 2.w,
          ),
        Flexible(
            child: Text(
          widget.micSeatState.state == 1
              ? widget.micSeatState.user?.nickname ?? ''
              : (widget.index == 1)
                  ? "特邀嘉宾"
                  : (widget.index == 8 || widget.index <= 1)
                      ? "连麦"
                      : '号麦位',
          overflow: TextOverflow.ellipsis,
          style: AppTheme()
              .textStyle(fontSize: 11, color: AppTheme.colorTextWhite),
          textAlign: TextAlign.center,
        ))
      ],
    );
  }
}
