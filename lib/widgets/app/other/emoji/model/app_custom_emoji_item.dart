import 'package:flutter/material.dart';

import 'app_custom_emoji_category_type.dart';

/// A class to store data for each individual emoji
@immutable
class AppCustomEmojiItem {
  /// Emoji constructor
  const AppCustomEmojiItem(this.name, this.format,
      {this.emojis, this.isShowEnd = false, this.isRandom = false});

  final String name;
  final String format;

  //是否随机抽一个gif
  final bool isRandom;
  final List<String>? emojis;

  //是否显示最后一帧
  final bool isShowEnd;
}
