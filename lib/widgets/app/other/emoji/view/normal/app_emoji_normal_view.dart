import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/tabs.dart';
import 'package:youyu/widgets/app/other/emoji/view/app_emoji_sub_view.dart';

class AppEmojiNormalView with AppEmojiSubView {
  AppEmojiNormalView({required this.config});

  final Config config;

  ///CategoryEmoji
  @override
  Tab createTab(category) {
    return Tab(
      icon: Icon(
        config.getIconForCategory(category.category),
      ),
    );
  }

}
