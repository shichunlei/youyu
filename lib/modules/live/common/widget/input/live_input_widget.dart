import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/controllers/app_controller.dart';
import 'package:youyu/services/trtc/trtc_service.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/app_round_container.dart';
import 'package:youyu/widgets/app/button/app_image_button.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveInputWidget extends StatelessWidget {
  const LiveInputWidget({
    super.key,
    required this.onClickInput,
    required this.onClickVolume,
    required this.onClickCloseMic,
    required this.onClickOpenMic,
    required this.onClickUpMicTap,
    required this.onClickDownMicTap,
    required this.onClickBottomMore,
    required this.onClickMsg,
    required this.onClickGift,
    required this.onClickEmoji,
  });

  final Color _bgColor = const Color(0xFF333B3B);
  final Function onClickInput;
  final GestureTapCallback onClickVolume;
  final Function onClickCloseMic;
  final Function onClickOpenMic;
  final GestureTapCallback onClickUpMicTap;
  final GestureTapCallback onClickDownMicTap;
  final Function onClickBottomMore;
  final Function onClickMsg;
  final Function onClickGift;
  final Function onClickEmoji;

  @override
  Widget build(BuildContext context) {
    return Obx(() => AppRow(
      padding: EdgeInsets.only(left: 13.w, right: 13.w),
      margin: EdgeInsets.only(bottom: ScreenUtils.safeBottomHeight),
      height: 44.h,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _chatWidget(),
        SizedBox(
          width: 8.w,
        ),
        const Expanded(child: SizedBox()),
        _audioWidget(),
        SizedBox(
          width: 8.w,
        ),
        _muteWidget(),
        SizedBox(
          width: 8.w,
        ),
        _rightWidget()
      ],
    ));
  }

  ///聊天框
  _chatWidget() {
    return AppRoundContainer(
        onTap: () {
          onClickInput();
        },
        alignment: Alignment.center,
        width: TRTCService().isUpMic.value ? 102.w : 112.w,
        height: 30.h,
        padding: EdgeInsets.only(right: 7.w),
        bgColor: _bgColor,
        child: Row(
          children: [
            AppContainer(
              onTap: () {
                onClickEmoji();
              },
              width: (16 + 7 * 2).w,
              height: double.infinity,
              child: Center(
                child: AppLocalImage(
                  path: AppResource().liveEmoji,
                  width: 16.w,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 8.w),
              height: 14.h,
              width: 1.w,
              color: AppTheme.colorTextWhite,
            ),
            Expanded(
                child: Text(
              "聊一聊...",
              style: AppTheme().textStyle(
                  fontSize: 14.sp, color: AppTheme.colorTextWhite),
            ))
          ],
        ));
  }

  ///声音
  _audioWidget() {
    return TRTCService().isCloseVolume.value
        ? AppLocalImage(
            onTap: onClickVolume,
            path: AppResource().liveAudioClose,
            width: 30.w,
            height: 30.w,
            fit: BoxFit.cover,
          )
        : AppLocalImage(
            onTap: onClickVolume,
            path: AppResource().liveAudioOpen,
            width: 30.w,
            height: 30.w,
            fit: BoxFit.cover,
          );
  }

  ///mute
  _muteWidget() {
    // 麦克风开关
    return TRTCService().isUpMic.value
        ? SizedBox(
            width: 30.w,
            height: 30.w,
            child: TRTCService().isMuted.value
                ? AppImageButton(
                    path: AppResource().liveIsMute,
                    width: 30.w,
                    onClick: onClickCloseMic)
                : AppImageButton(
                    path: AppResource().liveUnMute,
                    width: 30.w,
                    onClick: onClickOpenMic))
        : const SizedBox();
  }

  ///右边按钮
  _rightWidget() {
    return Row(
      children: [
        //上下麦
        !TRTCService().isUpMic.value
            ? AppRoundContainer(
                alignment: Alignment.center,
                onTap: onClickUpMicTap,
                bgColor: _bgColor,
                width: 48.w,
                height: 30.h,
                child: Text(
                  "上麦",
                  style: AppTheme().textStyle(
                      fontSize: 14.sp, color: AppTheme.colorTextWhite),
                ),
              )
            : AppRoundContainer(
                alignment: Alignment.center,
                onTap: onClickDownMicTap,
                width: 48.w,
                height: 30.h,
                bgColor: _bgColor,
                child: Text(
                  "下麦",
                  style: AppTheme().textStyle(
                      fontSize: 14.sp, color: AppTheme.colorTextWhite),
                ),
              ),
        SizedBox(
          width: 8.w,
        ),

        ///菜单设置
        AppImageButton(
            path: AppResource().liveSetBtn,
            width: 30.w,
            onClick: onClickBottomMore),

        SizedBox(
          width: 8.w,
        ),

        ///消息
        AppStack(
          children: [
            AppImageButton(
                path: AppResource().liveMsgBtn,
                width: 30.w,
                onClick: onClickMsg),
            Positioned(
                top: 0,
                right: 0,
                child: Obx(() => AppController.to.imUnReadCount > 0
                    ? AppContainer(
                        color: AppTheme.colorRed,
                        radius: 99.h,
                        width: 8.w,
                        height: 8.w,
                      )
                    : const SizedBox.shrink()))
          ],
        ),

        SizedBox(
          width: 8.w,
        ),

        ///礼物
        AppImageButton(
            path: AppResource().liveGiftBtn,
            width: 30.w,
            onClick: onClickGift)
      ],
    );
  }
}
