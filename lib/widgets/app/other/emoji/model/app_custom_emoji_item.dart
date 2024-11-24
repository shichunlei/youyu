import 'package:flutter/material.dart';

import 'app_custom_emoji_category_type.dart';

/// A class to store data for each individual emoji
@immutable
class AppCustomEmojiItem {
  /// Emoji constructor
  const AppCustomEmojiItem(this.categoryType, this.name, this.emojis);

  final AppCustomEmojiType categoryType;

  /// The name or description for this emoji
  final String name;

  final List<String> emojis;
}
