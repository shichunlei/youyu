import 'package:youyu/utils/platform_utils.dart';
import 'package:youyu/utils/screen_utils.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart' as emoji;
import 'package:youyu/config/theme.dart';

///emoji表情
class AppEmojiWidget extends StatelessWidget {
  const AppEmojiWidget(
      {super.key, this.editingController, this.onEmojiSelected,this.onBackspacePressed});

  final TextEditingController? editingController;
  final OnEmojiSelected? onEmojiSelected;
  final OnBackspacePressed? onBackspacePressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: emoji.EmojiPicker(
        onEmojiSelected: onEmojiSelected,
        onBackspacePressed:onBackspacePressed,
        textEditingController: editingController,
        // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
        config: emoji.Config(
          columns: 7,
          emojiSizeMax: 32 * (PlatformUtils.isIOS ? 1.20 : 1.0),
          // Issue: https://github.com/flutter/flutter/issues/28894
          verticalSpacing: 0,
          horizontalSpacing: 0,
          gridPadding: EdgeInsets.symmetric(horizontal: 8.w),
          initCategory: emoji.Category.RECENT,
          bgColor: AppTheme.colorDarkBg,
          indicatorColor: AppTheme.colorMain,
          iconColor: Colors.grey,
          iconColorSelected: AppTheme.colorMain,
          backspaceColor: AppTheme.colorMain,
          skinToneDialogBgColor: Colors.white,
          skinToneIndicatorColor: Colors.grey,
          enableSkinTones: true,
          recentTabBehavior: emoji.RecentTabBehavior.RECENT,
          recentsLimit: 28,
          noRecents: Text(
            '暂无常用表情',
            style: TextStyle(
                fontSize: 20.sp, color: AppTheme.colorTextSecond),
            textAlign: TextAlign.center,
          ),
          tabIndicatorAnimDuration: kTabScrollDuration,
          categoryIcons: const emoji.CategoryIcons(),
          buttonMode: emoji.ButtonMode.CUPERTINO,
        ),
      ),
    );
  }
}
