import 'package:youyu/utils/screen_utils.dart';

import 'package:youyu/config/resource.dart';
import 'package:youyu/config/theme.dart';
import 'package:youyu/modules/primary/discover/publish/bottom/discover_audio_record_widget.dart';
import 'package:youyu/modules/primary/discover/publish/discover_publish_logic.dart';
import 'package:youyu/widgets/app/app_base_widget.dart';
import 'package:youyu/widgets/app/image/app_local_image.dart';
import 'package:youyu/widgets/app/other/app_emoji_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiscoverBottomMoreWidget extends StatelessWidget {
  const DiscoverBottomMoreWidget({super.key, required this.logic});

  final DiscoverPublishLogic logic;

  @override
  Widget build(BuildContext context) {
    return Obx(() => AppColumn(
          color: AppTheme.colorDarkBg,
          children: [
            _top(),
            _audio(),
            _emoji(),
            Container(
              height: ScreenUtils.safeBottomHeight,
            )
          ],
        ));
  }

  _top() {
    return AppRow(
      height: 76.h,
      children: [
        Expanded(
            child: AppContainer(
          onTap: logic.onClickEmoji,
          child: Center(
            child: AppLocalImage(
              imageColor: logic.pageState == DiscoverPageState.emoji
                  ? AppTheme.colorMain
                  : AppTheme.colorTextWhite,
              path: AppResource().disEmoji,
              width: 25.w,
            ),
          ),
        )),
        Expanded(
            child: AppContainer(
          onTap: logic.onClickAudio,
          child: Center(
            child: AppLocalImage(
              imageColor: logic.pageState == DiscoverPageState.audio
                  ? AppTheme.colorMain
                  : AppTheme.colorTextWhite,
              path: AppResource().disAudioIcon,
              width: 20.w,
            ),
          ),
        )),
        Expanded(
            child: AppContainer(
          onTap: logic.onClickImage,
          child: Center(
            child: AppLocalImage(
              path: AppResource().disImgIcon,
              width: 25.w,
            ),
          ),
        )),
        Expanded(
            child: AppContainer(
          onTap: logic.onClickAt,
          child: Center(
            child: AppLocalImage(
              path: AppResource().disAt,
              width: 25.w,
            ),
          ),
        )),
      ],
    );
  }

  _audio() {
    if (logic.pageState == DiscoverPageState.emoji) {
      return Container();
    }
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: SizedBox(
        width: double.infinity,
        height: logic.pageState == DiscoverPageState.audio ? 263.h : 0,
        child: logic.pageState == DiscoverPageState.audio
            ? DiscoverAudioRecordWidget(logic: logic,)
            : const SizedBox.shrink(),
      ),
    );
  }

  _emoji() {
    if (logic.pageState == DiscoverPageState.audio) {
      return Container();
    }
    return AnimatedSize(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: SizedBox(
          width: double.infinity,
          height: logic.pageState == DiscoverPageState.emoji ? 263.h : 0,
          child: logic.pageState == DiscoverPageState.emoji
              ? AppEmojiWidget(
                  onBackspacePressed:(){},
                  editingController: logic.contentController,
                )
              : Container(),
        ));
  }
}
